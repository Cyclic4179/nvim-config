{ pkgs, inputs }:
let
  extraPackages = with pkgs; [
    # search
    ripgrep
    fd # suggested by telescope-nvim heathcheck

    # unzip
    unzip

    # lsp
    # nix
    nil

    rust-analyzer

    nodePackages_latest.dockerfile-language-server-nodejs
    #nodePackages.eslint
    nodePackages.typescript-language-server
    lua-language-server

    pyright

    (python3.withPackages (
      ps:
      with ps;
      [
        python-lsp-server
        (python-lsp-black.override { pytestCheckHook = null; }) # didnt build with tests enabled :shrug:
        pyls-isort
        pylsp-mypy
      ]
      ++ python-lsp-server.optional-dependencies.all
    ))

    # c
    clang-tools
    #libclang
    #llvmPackages.clang-unwrapped
    #clang
    #llvmPackages.libcxxClang
    ##llvmPackages.libcClang
    #llvmPackages.libllvm
    gdb

    texlab

    # ocaml
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    dune_3 # otherwise sometimes the lsp wont work

    #java-language-server
    jdt-language-server

    # go
    go
    delve
    gopls
  ];

  extraPlugins = with pkgs.vimPlugins; [
    #LazyVim

    # theme
    # until nixpkgs has newer rose-pine version
    #rose-pine
    (pkgs.vimUtils.buildVimPlugin {
      pname = "rose-pine";
      version = "2024-08-25";
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "neovim";
        rev = "8b1fd252255a7f2c41b4192a787ab62660b29f72";
        sha256 = "sha256-KYlt0ryKTBV5vimnq3rxEQOhkiqLK/EV7zMxVNdSUTY=";
      };
      meta.homepage = "https://github.com/rose-pine/neovim/";
    })
    tokyonight-nvim

    # icons -> for oil-nvim, telescope-nvim
    nvim-web-devicons

    # trying out ...
    trouble-nvim

    telescope-nvim

    nvim-treesitter
    #nvim-treesitter.withAllGrammars
    #playground # treesitter playground
    nvim-treesitter-context
    # nvim-treesitter-textobjects # i dont need this

    # Link together all treesitter grammars into single derivation
    # for some reason we need to do this
    #(pkgs.symlinkJoin {
    #  name = "nix-treesitter-parsers";
    #  paths = nvim-treesitter.withAllGrammars.dependencies;
    #})

    nvim-autopairs

    undotree

    # java lsp
    #nvim-jdtls # annoying config (cant with lspconfig, didnt investigate further)
    nvim-jdtls

    # tpope/vim-fugitive
    vim-fugitive

    #vim-visual-multi # idk if i want this
    #multicursors-nvim
    #multiple-cursors

    # netrw replacement
    oil-nvim

    conform-nvim
    # doesnt exist in nixpkgs
    (pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-colorizer.lua";
      version = "2024-05-10";
      src = pkgs.fetchFromGitHub {
        owner = "norcalli";
        repo = "nvim-colorizer.lua";
        rev = "a065833f35a3a7cc3ef137ac88b5381da2ba302e";
        sha256 = "sha256-gjO89Sx335PqVgceM9DBfcVozNjovC8KML1OZCRNMGw=";
      };
      meta.homepage = "https://github.com/norcalli/nvim-colorizer.lua";
    })

    # harpoon
    harpoon2

    # completion
    nvim-cmp
    cmp-buffer
    cmp-calc
    cmp-path
    cmp-cmdline
    cmp-nvim-lua
    # lsp
    nvim-lspconfig
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-nvim-lua
    # snippets
    luasnip
    cmp_luasnip
    # formatting
    lspkind-nvim

    # debugger
    nvim-dap-ui
    nvim-dap
    nvim-nio # required for some reason
    nvim-dap-virtual-text
    nvim-dap-go

    # nix file detection
    #vim-nix # i dont use this

    # personal config
    #{
    #  name = "config";
    #  outPath = "${./config}";
    #}
  ];

  globalVars = {
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
    # Link together all treesitter grammars into single derivation
    # for some reason we need to do this
    TREESITTER_PARSER_PATH = (pkgs.symlinkJoin {
      name = "nix-treesitter-parsers";
      paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    });
  };

  globalVarsString = builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: ''let g:${name} = "${value}"'') globalVars);

  lib = pkgs.lib;

  pluginPath = pkgs.linkFarm "lazyvim-nix-plugins" (builtins.map mkEntryFromDrv extraPlugins);

  mkEntryFromDrv =
    drv:
    if lib.isDerivation drv then
      {
        name = "${lib.getName drv}";
        path = drv;
      }
    else
      drv;

  # Link together all treesitter grammars into single derivation
  # for some reason we need to do this
  treesitter-parsers = (pkgs.symlinkJoin {
    name = "nix-treesitter-parsers";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  });


  #envVarString = lib.pipe extraEnvVars [
  #  builtins.attrNames
  #  (builtins.map (name: "${name}=${extraEnvVars.${name}}"))
  #  (builtins.concatStringsSep " ")
  #];
  #envVarString = builtins.concatStringsSep " " (
  #  builtins.map (name: "${name}=${extraEnvVars.${name}}") (builtins.attrNames extraEnvVars)
  #);

  # paths to executables that should be available when running nvim
  extraMakeWrapperArgsPath = ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
  # env vars for configuration, probably better done differently :man_shrugging:
  #extraMakeWrapperArgsEnvVars = builtins.concatStringsSep " " (
  #  lib.mapAttrsToList (name: value: ''--set ${name} ${value}'') globalVars
  #);

  #neovimRuntimeDependencies = pkgs.symlinkJoin {
  #  name = "neovimRuntimeDependencies";
  #  paths = extraPackages;
  #};

  recCatContent =
    path:
    lib.pipe path [
      builtins.readDir
      (lib.mapAttrsToList (
        name: value:
        let
          newp = "${path}/${name}";
        in
        if value == "regular" then builtins.readFile newp else recCatContent newp
      ))
      (builtins.concatStringsSep "\n")
    ];

  trace = t: builtins.trace t t;

  luaInitConfig = recCatContent ./lua/config;
  lazyUserPluginDir = pkgs.runCommand "lazy-user-plugins" { } ''
    mkdir -p $out/lua/plugins
    cp -r ${./lua/plugins}/* $out/lua/plugins/
  '';

  neovimWrapped = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    #extraMakeWrapperArgs = "${extraMakeWrapperArgsPath} ${extraMakeWrapperArgsEnvVars}";
    extraMakeWrapperArgs = extraMakeWrapperArgsPath;
    configure = {
      customRC = # vim
        ''
          " populate paths to neovim
          ${globalVarsString}

          lua<<EOF
          ${luaInitConfig}

          require("lazy").setup({
            --defaults = { lazy = true },
            dev = {
              -- reuse files from pkgs.vimPlugins.*
              path = "${pluginPath}",
              --path = vim.g.plugin_path,
              patterns = { "." },
              -- fallback to download
              fallback = false,
            },
            spec = {
              --{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
              --{ import = "lazyvim.plugins.extras.coding.yanky" },
              --{ import = "lazyvim.plugins.extras.dap.core" },
              --{ import = "lazyvim.plugins.extras.lang.clangd" },
              --{ import = "lazyvim.plugins.extras.lang.cmake" },
              --{ import = "lazyvim.plugins.extras.lang.markdown" },
              --{ import = "lazyvim.plugins.extras.lang.rust" },
              --{ import = "lazyvim.plugins.extras.lang.yaml" },
              --{ import = "lazyvim.plugins.extras.lsp.none-ls" },
              --{ import = "lazyvim.plugins.extras.test.core" },
              --{ import = "lazyvim.plugins.extras.util.project" },
              -- The following configs are needed for fixing lazyvim on nix
              -- force enable telescope-fzf-native.nvim
              -- { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
              -- disable mason.nvim, use config.extraPackages
              --{ "williamboman/mason-lspconfig.nvim", enabled = false },
              --{ "williamboman/mason.nvim", enabled = false },
              --{ "jaybaby/mason-nvim-dap.nvim", enabled = false },
              -- uncomment to import/override with your plugins
              { import = "plugins" },
              -- put this line at the end of spec to clear ensure_installed
              --{ dir = "$${trace (toString pkgs.vimPlugins.nvim-treesitter.withAllGrammars)}" },
              --{
              --  "nvim-treesitter/nvim-treesitter",
              --  init = function()
              --    -- Put treesitter path as first entry in rtp
              --    --vim.opt.rtp:prepend("$${trace (toString treesitter-parsers)}")
              --    vim.opt.rtp:prepend("${treesitter-parsers}")
              --    --require 'nvim-treesitter.configs'.setup {
              --    --  parser_install_dir = "${treesitter-parsers}",
              --    --  highlight = {
              --    --    enable = true,
              --    --  },

              --    --  indent = {
              --    --    enable = true
              --    --  },

              --    --  --incremental_selection = {
              --    --  --    enable = true,
              --    --  --    keymaps = {
              --    --  --        init_selection = "gnn", -- set to `false` to disable one of the mappings
              --    --  --        node_incremental = "grn",
              --    --  --        scope_incremental = "grc",
              --    --  --        node_decremental = "grm",
              --    --  --    },
              --    --  --},
              --    --}
              --    --vim.opt.rtp:prepend(vim.g.treesitter_path)
              --  end,
              --  opts = { auto_install = false, ensure_installed = {} },
              --},
            },
            performance = {
              rtp = {
                -- Setup correct config path
                paths = { "${lazyUserPluginDir}" },
                disabled_plugins = {
                  "gzip",
                  "matchit",
                  "matchparen",
                  "netrwPlugin",
                  "tarPlugin",
                  "tohtml",
                  "tutor",
                  "zipPlugin",
                },
              },
            },
          })
          EOF
        '';
      packages.all.start = [ pkgs.vimPlugins.lazy-nvim ];
    };
    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
    #vimAlias = true;
  };
in
#pkgs.neovimBuilder {
#  inherit plugins;
#
#  # packages needed
#  extraMakeWrapperArgs = extraMakeWrapperArgsPath + " " + extraMakeWrapperArgsEnvVars;
#}
#pkgs.writeShellApplication {
#  name = "nvim";
#  runtimeInputs = [ neovimRuntimeDependencies ];
#  text = ''
#    ${envVarString} ${neovimWrapped}/bin/nvim "$@"
#  '';
#}
neovimWrapped
