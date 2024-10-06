{
  pkgs,
  lib,
  inputs,
}@args:

let
  inherit (import ./lib.nix args) prettyTrace;

  recMapNix = import ./map.nix args;

  cfg = prettyTrace (recMapNix "lua/plugins" ./test);

  pluginPath = pkgs.linkFarm "lazyvim-nix-plugins" (builtins.map mkEntryFromDrv cfg.vimPlugins);

  mkEntryFromDrv =
    drv:
    if lib.isDerivation drv then
      {
        name = "${lib.getName drv}";
        path = drv;
      }
    else
      drv;

  # paths to executables that should be available when running nvim
  extraMakeWrapperArgsPath =
    let
      binPath = lib.makeBinPath cfg.extraPackages;
    in
    [
      "--suffix"
      "PATH"
      ":"
      binPath
    ];

  # TODO: local path references are useless (?) in *.lua.nix files
  # TODO: if i want to move this, i need to provide a `final` or sth argument
  # maybe use lib.fix for this
  # see https://github.com/hsjobeki/nixpkgs/blob/migrate-doc-comments/pkgs/applications/editors/neovim/wrapper.nix
  # copied from https://github.com/nvim-neorocks/rocks.nvim/blob/b24f15ace8542882946222bbc2be332ed57a0861/nix/plugin-overlay.nix#L196
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;

    viAlias = false;
    vimAlias = true;

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
            },
            performance = {
              rtp = {
                -- Setup correct config path
                paths = { "${cfg.luaCfg}" },
                disabled_plugins = {
                  --"gzip",
                  "matchit",
                  "matchparen",
                  "netrwPlugin",
                  --"tarPlugin",
                  "tohtml",
                  "tutor",
                  --"zipPlugin",
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

neovimWrapped
