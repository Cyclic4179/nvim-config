{ pkgs, ... }:
{
  binaries = [ ];
  lazy =
    with pkgs.vimPlugins;
    # lua
    ''
      {
        -- "mbbill/undotree",
        dir = "${undotree}",
        name = "undotree",
        keys = {
          {
            "<leader>u",
            vim.cmd.UndotreeToggle,
          },
        },
        init = function()
          vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
          vim.opt.undofile = true
        end,
      },
    '';
}
