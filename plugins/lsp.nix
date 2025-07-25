{ pkgs, ... }:

let
  # (julia.withPackages [ "LanguageServer" ]) -> path issues and therefore different approach
  JULIA_WITH_LS_PATH = pkgs.lib.getExe (pkgs.julia.withPackages [ "LanguageServer" ]);
  JULIA_LS_START_FILE =
    builtins.toFile "StartLanguageServer.jl" # julia
      ''
        using LanguageServer

        depot_path = get(ENV, "JULIA_DEPOT_PATH", "")

        project_path = let
            dirname(something(
                ## 1. Finds an explicitly set project (JULIA_PROJECT)
                Base.load_path_expand((
                    p = get(ENV, "JULIA_PROJECT", nothing);
                    p === nothing ? nothing : isempty(p) ? nothing : p
                )),
                ## 2. Look for a Project.toml file in the current working directory,
                ##    or parent directories, with $HOME as an upper boundary
                Base.current_project(),
                ## 3. First entry in the load path
                get(Base.load_path(), 1, nothing),
                ## 4. Fallback to default global environment,
                ##    this is more or less unreachable
                Base.load_path_expand("@v#.#"),
            ))
        end

        @info "Running language server" VERSION pwd() project_path depot_path

        server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
        server.runlinter = true
        run(server)
      '';
in

{
  binaries = with pkgs; [
    ruff
    pyright
    gopls
    ocamlPackages.ocaml-lsp
    lua-language-server
    nil
    texlab
    zls
    rust-analyzer
    zls
    # nodePackages_latest.dockerfile-language-server-nodejs
    # nodePackages.eslint
    nodePackages.typescript-language-server
  ];
  lazy =
    with pkgs.vimPlugins;
    # lua
    ''
      {
        -- "neovim/nvim-lspconfig",
        dir = "${nvim-lspconfig}",
        name = "nvim-lspconfig",
        event = { "BufRead" },
        dependencies = {
          -- "hrsh7th/cmp-nvim-lsp",
          { dir = "${cmp-nvim-lsp}", name = "cmp-nvim-lsp" }
        },
        config = function()
          -- Setup language servers.
          local lspconfig = require("lspconfig")

          -- Set up lspconfig.
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          -- NOTE: set capabilities for each server:
          --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
          --    capabilities = capabilities
          --}

          -- PYTHON

          lspconfig.ruff.setup({
            capabilities = capabilities,
            -- Server settings should go here
            -- init_options = { settings = {} },
          })

          lspconfig.pyright.setup({
            capabilities = capabilities,
            -- see https://docs.astral.sh/ruff/editors/setup/#neovim
            setting = {
              pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
              },
              python = {
                analysis = {
                  -- Ignore all files for analysis to exclusively use Ruff for linting
                  ignore = { "*" },
                },
              },
            },
          })

          -- OCAML
          lspconfig.ocamllsp.setup({ capabilities = capabilities })

          -- JAVA
          --lspconfig.java_language_server.setup {
          --    capabilities = capabilities,
          --    cmd = { 'java-language-server' }
          --}

          lspconfig.julials.setup({})
          lspconfig.ts_ls.setup({ capabilities = capabilities })
          lspconfig.rust_analyzer.setup({ capabilities = capabilities })
          lspconfig.nil_ls.setup({
            capabilities = capabilities,
            autostart = true,
          })
          lspconfig.zls.setup({ capabilities = capabilities })
          lspconfig.clangd.setup({ capabilities = capabilities })
          lspconfig.dockerls.setup({ capabilities = capabilities })
          lspconfig.texlab.setup({ capabilities = capabilities })
          lspconfig.julials.setup({
            capabilities = capabilities,
            cmd = {
              "${JULIA_WITH_LS_PATH}",
              "--startup-file=no",
              "--history-file=no",
              "${JULIA_LS_START_FILE}",
            },
            -- This just adds dirname(fname) as a fallback -> linting also works in single file mode
            -- copied from https://github.com/fredrikekre/.dotfiles/blob/4c4c6c0cbd24cb53b24de1d68377d670244b87be/.config/nvim/lua/plugins/lsp.lua#L54-L57
            -- see https://github.com/neovim/nvim-lspconfig/blob/40f120c10ea4b87311175539a183c3b75eab95a3/lua/lspconfig/configs/julials.lua#L100-L103
            root_dir = function(fname)
              local root_files = { "Project.toml", "JuliaProject.toml" }
              local util = require("lspconfig.util")
              return util.root_pattern(unpack(root_files))(fname)
                or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
                or vim.fs.dirname(fname)
            end,

            -- settings = {
            --     julia = {
            --         executablePath = "";
            --     }
            -- }
          })
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                  enable = false,
                },
              },
            },
          })
          lspconfig.gopls.setup({
            -- for postfix snippets and analyzers
            capabilities = capabilities,
            settings = {
              gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                  unusedparams = true,
                  shadow = true,
                },
                staticcheck = true,
              },
            },
          })

          local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
          for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end

          vim.diagnostic.config({
            virtual_text = true,
          })

          -- see https://vi.stackexchange.com/questions/39074/user-borders-around-lsp-floating-windows
          local _border = "rounded" -- none single double rounded solid shadow

          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = _border,
          })

          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = _border,
          })

          vim.diagnostic.config({
            float = { border = _border },
          })

          require("lspconfig.ui.windows").default_options = {
            border = _border,
          }
        end,
      },


      ------ old python config ------

      --lspconfig.jdtls.setup {
      --    capabilities = capabilities,
      --    cmd = { "jdt-language-server", "-data", home .. "/.cache/jdtls/workspace" },
      --    root_dir = function(fname)
      --		return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
      --	end,
      --}

      -- resolved by settings PYTHONPATH (https://jdhao.github.io/2023/07/22/neovim-pylsp-setup)
      --local venv_path = os.getenv('VIRTUAL_ENV')
      --local py_path = nil
      ---- decide which python executable to use for mypy
      --if venv_path ~= nil then
      --    py_path = venv_path .. "/bin/python3"
      --else
      --    py_path = vim.g.python3_host_prog
      --end

      -- INFO: last config
      -- lspconfig.pylsp.setup({
      --     settings = {
      --         pylsp = {
      --             plugins = {
      --                 -- formatter options
      --                 black = { enabled = true },
      --                 autopep8 = { enabled = false },
      --                 yapf = { enabled = false },
      --                 -- linter options
      --                 pylint = { enabled = true, executable = "pylint" },
      --                 ruff = { enabled = false },
      --                 pyflakes = { enabled = false },
      --                 pycodestyle = { enabled = false },
      --                 -- type checker
      --                 pylsp_mypy = {
      --                     enabled = true,
      --                     --overrides = { "--python-executable", py_path, true },
      --                     report_progress = true,
      --                     live_mode = false,
      --                 },
      --                 -- auto-completion options
      --                 jedi_completion = { fuzzy = true },
      --                 -- import sorting
      --                 isort = { enabled = true },
      --             },
      --         },
      --     },
      --     flags = {
      --         debounce_text_changes = 200,
      --     },
      --     capabilities = capabilities,
      -- })

      -- INFO: didnt use
      -- lspconfig.pylsp.setup {
      --     capabilities = capabilities,
      --     settings = {
      --         pylsp = {
      --             plugins = {
      --                 --ruff = {
      --                 --    enabled = true,
      --                 --    extendSelect = { "I" },
      --                 --    --lineLength = 160
      --                 --},
      --                 --mypy = {
      --                 --    enabled = false,
      --                 --    live_mode = true,
      --                 --    strict = true
      --                 --}
      --             }
      --         }
      --     }
      -- }

      -- also tried this
      -- lspconfig.pylsp.setup { capabilities = capabilities }
    '';
}
