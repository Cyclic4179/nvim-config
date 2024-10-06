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
    lib.mapAttrsToList (name: value: ''vim.g.${name} = "${value}"'') globalVars
  );

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

  luaInitConfig = recCatContent ./lua/config;
  lazyUserPluginDir = pkgs.runCommand "lazy-user-plugins" { } ''
    mkdir -p $out/lua/plugins
    cp -r ${./lua/plugins}/* $out/lua/plugins/
  '';

  # see https://github.com/hsjobeki/nixpkgs/blob/migrate-doc-comments/pkgs/applications/editors/neovim/wrapper.nix
  # copied from https://github.com/nvim-neorocks/rocks.nvim/blob/b24f15ace8542882946222bbc2be332ed57a0861/nix/plugin-overlay.nix#L196
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;

    viAlias = false;
    vimAlias = false;

    plugins = [
      pkgs.vimPlugins.lazy-nvim
    ];
  };
  neovimWrapped = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
    neovimConfig
    // {
      luaRcContent =
        # lua
        ''
          -- populate paths to neovim
          ${globalVarsString}

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
        '';
      wrapRc = true; # sets -u <vimrc> (and hence ignores local .vimrc, ...)
      wrapperArgs = neovimConfig.wrapperArgs ++ extraMakeWrapperArgsPath;
      neovimRcContent = if neovimConfig.neovimRcContent == "" then null else neovimConfig.neovimRcContent;
    }
  );
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
