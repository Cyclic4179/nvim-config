{ pluginPath, pluginDir, ... }:
# lua
''
  require("lazy").setup({
    --root = nil;
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
        paths = { "${pluginDir}" },
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
''
