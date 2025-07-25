{ pkgs, ... }:
{
  binaries = [ ];
  lazy =
    with pkgs.vimPlugins;
    let
      # Link together all treesitter grammars into single derivation
      # for some reason we need to do this
      TREESITTER_PARSER_PATH = (
        pkgs.symlinkJoin {
          name = "nix-treesitter-parsers";
          paths = nvim-treesitter.withAllGrammars.dependencies;
        }
      );
    in
    # lua
    ''
      {
        dir = "${nvim-treesitter}",
        name = "nvim-treesitter",
        event = "VeryLazy",
        config = function ()
          vim.opt.runtimepath:append("${TREESITTER_PARSER_PATH}")
          require("nvim-treesitter.configs").setup {
            -- they are managed by nix
            auto_install = false,

            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn", -- set to `false` to disable one of the mappings
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
          }
        end
      },
    '';
}
