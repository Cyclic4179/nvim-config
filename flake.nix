{
  description = "nvim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # used for java styleguide
    google-styleguide.url = "github:google/styleguide/gh-pages";
    google-styleguide.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    {
      overlays.default = [ (final: prev: { neovim = self.packages.${prev.system}.neovim; }) ];
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        # installs a vim plugin from git
        plugin = with pkgs; repo: vimUtils.buildVimPlugin {
          pname = "${lib.strings.sanitizeDerivationName repo}";
          version = "main";
          src = builtins.getAttr repo inputs;
        };

        # TODO auto import all nix files except flake.nix itself
        files = [
          ./plugins/colors.nix
          ./plugins/completion.nix
          ./plugins/debugging.nix
          ./plugins/formatting.nix
          ./plugins/git.nix
          ./plugins/harpoon.nix
          ./plugins/java-lsp.nix
          ./plugins/lsp.nix
          ./plugins/oil.nix
          ./plugins/stuff.nix
          ./plugins/telescope.nix
          ./plugins/treesitter.nix
          ./plugins/trouble.nix
          ./plugins/undotree.nix
        ];
        plugins = map (name: import name { inherit pkgs plugin inputs; }) files;
        binaries = map (x: x.binaries) plugins;
        lazySpec = builtins.concatStringsSep "\n" (map (x: x.lazy) plugins);
      in
      with pkgs; rec {
        apps.default = flake-utils.lib.mkApp {
          drv = packages.default;
          name = "nvim";
        };

        packages.default = wrapNeovimUnstable neovim-unwrapped {
          viAlias = true;
          vimAlias = true;

          withPython3 = false;
          withRuby = false;

          # NOTE: --prefix makes binaries have higher precedence than those in PATH
          wrapperArgs =
            with lib;
            ''--prefix PATH : "${makeBinPath (lists.unique (lists.flatten binaries))}"'';

          # only lazy is needed, it handles the rest
          plugins = with pkgs.vimPlugins; [ lazy-nvim ];
          luaRcContent =
            # lua
            ''
              ${builtins.readFile ./config/autocmds.lua}
              ${builtins.readFile ./config/remap.lua}
              ${builtins.readFile ./config/set.lua}

              require("lazy").setup({
                -- disable all update / install features
                -- this is handled by nix
                rocks = { enabled = false },
                pkg = { enabled = false },
                install = { missing = false },
                change_detection = { enabled = false },
                spec = { ${lazySpec} },
                performance = {
                  rtp = {
                    disabled_plugins = {
                      --"gzip",
                      --"matchit",
                      --"matchparen",
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
          };
      }
    );
}
