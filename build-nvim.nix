{
  pkgs,
  lib,
  inputs,
}@args:

let
  extraPackages = import ./lua/extra-packages.nix args;
  extraPlugins = import ./lua/extra-plugins.nix args;
  globalVars = import ./lua/global-vars.nix args;

  globalVarsString = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: ''let g:${name} = "${value}"'') globalVars
  );

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
  treesitter-parsers = (
    pkgs.symlinkJoin {
      name = "nix-treesitter-parsers";
      paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    }
  );

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
              --    vim.opt.rtp:prepend("$${treesitter-parsers}")
              --    --require 'nvim-treesitter.configs'.setup {
              --    --  parser_install_dir = "$${treesitter-parsers}",
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
