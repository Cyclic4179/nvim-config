{ pkgs, inputs, ... }:
let
  JAVA_SE_17 = "${pkgs.jdk17}/lib/openjdk";
  # https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
  ECLIPSE_JAVA_GOOGLE_STYLE = "${inputs.google-styleguide}/eclipse-java-google-style.xml";
  VSCODE_JAVA_DEBUG_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
  #VSCODE_JAVA_TEST_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
  # wait until at least vscode-java-test 0.41 is out (https://github.com/microsoft/vscode-java-test/issues/1681)
  VSCODE_JAVA_TEST_PATH =
    let
      vscode-java-test =
        with pkgs;
        vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-java-test";
            publisher = "vscjava";
            version = "0.42.2024080106";
            hash = "sha256-bg6ckBp8VJwXDp877wqt4MAyBPNJZWog/aEptbSaPg4=";
          };
          meta = {
            license = lib.licenses.mit;
          };
        };
    in
    "${vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
in
{
  binaries = [ ];
  lazy =
    with pkgs.vimPlugins;
    # lua
    ''
      {
        -- "mfussenegger/nvim-jdtls",
        dir = "${nvim-jdtls}",
        name = "nvim-jdtls",
        dependencies = {
          -- "nvim-neotest/nvim-nio",
          { dir = "${nvim-nio}", name = "nvim-nio" }, -- used for async start of debugger
          -- "mfussenegger/nvim-dap",
          { dir = "${nvim-dap}", name = "nvim-dap" }, -- needed for debugger
        },
        ft = "java",
        config = function()
          -- TODO: this is not perfect
          -- (issues:
          --      can run debug_java multiple times, race may occur;
          --      if run main, then run junit but no junit fount, main runs again but not intended
          -- )
          local debug_java = function()
            local dap = require("dap")
            if dap.session() ~= nil then
              dap.continue()
            else
                  -- stylua: ignore
                  local choices = {
                      { label = "main class",           action = function() require("jdtls.dap").setup_dap_main_class_configs() end, },
                      { label = "junit test class",     action = function() require("jdtls.dap").test_class() end, },
                      { label = "junit nearest method", action = function() require("jdtls.dap").test_nearest_method() end, },
                      { label = "pick test",            action = function() require("jdtls.dap").pick_test() end, },
                  }
              vim.ui.select(choices, {
                prompt = "Choose what to debug (if available):",
                format_item = function(item)
                  return item.label
                end,
              }, function(choice)
                if (choice or {}).action then
                  choice.action()

                  local nio = require("nio")
                  nio.run(function()
                    for _ = 1, 6, 1 do -- wait 3 secs
                      nio.sleep(500)

                      if dap.session() == nil then -- if action already spawns debug session dont dap.continue()
                        dap.continue()
                        print("... still not ready")
                      else
                        print("debugger ready")
                        break
                      end
                    end
                  end)
                end
              end)
            end
          end

          local home = vim.fn.getenv("HOME")

          local eclipseJavaGoogleStyle = "${ECLIPSE_JAVA_GOOGLE_STYLE}"
          local java17path = "${JAVA_SE_17}"

          local vscode_java_debug_path = "${VSCODE_JAVA_DEBUG_PATH}"
          local vscode_java_test_path = "${VSCODE_JAVA_TEST_PATH}"

          local jdtls = require("jdtls")

          local on_attach = function(_, bufnr)
            -- Java extensions provided by jdtls
            --vim.keymap.set('n', '<C-o>', jdtls.organize_imports, opts)
            vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, { desc = "extract_variable", buffer = bufnr })
            vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, { desc = "extract_constant", buffer = bufnr })
            vim.keymap.set("v", "<leader>em", jdtls.extract_method, { desc = "extract_method", buffer = bufnr })
            vim.keymap.set("n", "<leader>dc", debug_java, { desc = "Debug opts for java", buffer = bufnr })
          end

          -- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

          local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

          -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
          local config = {
            -- Set up lspconfig.
            capabilities = require("cmp_nvim_lsp").default_capabilities(),

            cmd = {
              "jdtls",
              "-data",
              workspace_dir,
            },

            on_attach = on_attach,

            -- This is the default if not provided, you can remove it. Or adjust as needed.
            -- One dedicated LSP server & client will be started per unique root_dir
            --root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
            root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
            --root_dir = function(fname)
            --    return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
            --end,

            -- Here you can configure eclipse.jdt.ls specific settings
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- for a list of options
            settings = {
              java = {
                codeGeneration = {
                  toString = {
                    template = "''${object.className}{''${member.name()}=''${member.value}, ''${otherMembers}}",
                  },
                  hashCodeEquals = {
                    useJava7Objects = true,
                  },
                  useBlocks = true,
                },
                format = {
                  settings = {
                    -- Use Google Java style guidelines for formatting
                    url = eclipseJavaGoogleStyle,
                    profile = "GoogleStyle",
                  },
                },
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code
                configuration = {
                  runtimes = {
                    {
                      name = "JavaSE-17",
                      path = java17path,
                    },
                  },
                },
              },
            },
          }

          ----- dap
          -- java debugger: https://github.com/mfussenegger/nvim-jdtls#java-debug-installation

          -- setup debug config for main class
          -- :lua require("jdtls.dap").setup_dap_main_class_configs()
          -- or
          -- :JdtUpdateDebugConfigs

          -- functions for tests are:
          -- :lua require("jdtls.dap").test_class()
          -- :lua require("jdtls.dap").test_nearest_method()
          -- :lua require("jdtls.dap").pick_test()

          -- This bundles definition is the same as in the previous section (java-debug installation)
          local bundles = {
            vim.fn.glob(vscode_java_debug_path .. "/server/com.microsoft.java.debug.plugin-*.jar", 1),
          }

          -- This is the new part
          -- didnt work for some reason
          vim.list_extend(bundles, vim.split(vim.fn.glob(vscode_java_test_path .. "/server/*.jar", 1), "\n"))
          --vim.print(bundles)
          config["init_options"] = {
            bundles = bundles,
          }
          ----- dap-end

          -- This starts a new client & server,
          -- or attaches to an existing client & server depending on the `root_dir`.
          jdtls.start_or_attach(config)
        end,
      },
    '';
}
