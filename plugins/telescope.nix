{ pkgs, ... }:
{
  binaries = with pkgs; [ fd ripgrep ];
  lazy =
    with pkgs.vimPlugins;
    # lua
    ''
      {
        -- "nvim-telescope/telescope.nvim",
        dir = "${telescope-nvim}",
        name = "telescope.nvim",
        dependencies = {
          -- "nvim-lua/plenary.nvim",
          { dir = "${plenary-nvim}", name = "plenary.nvim" },
          { dir = "${nvim-web-devicons}", name = "nvim-web-devicons" },
        },
        cmd = "Telescope",
            -- stylua: ignore
            keys = {
                { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Telescope find_files", },
                { "<C-P>", function() require("telescope.builtin").git_files() end, desc = "Telescope git_files", },

                -- trying this thing out
                { "<leader>pr", function() require("telescope.builtin").resume() end, desc = "Telescope resume", },

                -- TODO not sure how nice this is
                --local is_inside_work_tree = {}
                --vim.keymap.set('n', '<C-P>', function ()
                --  local opts = {} -- define here if you want to define something
                --
                --  local cwd = vim.fn.getcwd()
                --  if is_inside_work_tree[cwd] == nil then
                --    vim.fn.system("git rev-parse --is-inside-work-tree")
                --    is_inside_work_tree[cwd] = vim.v.shell_error == 0
                --  end
                --
                --  if is_inside_work_tree[cwd] then
                --    require 'telescope.builtin'.git_files(opts)
                --  else
                --    require 'telescope.builtin'.find_files(opts)
                --  end
                --
                --end)

                { "<leader>ps", function()
                    local grep_str = vim.fn.input("Grep > ")
                    if grep_str ~= "" then require("telescope.builtin").grep_string({ search = grep_str }) end
                end, desc = "Telescope grep_string", },
                { "<leader>pt", function() require("telescope.builtin").grep_string({ search = "TODO" }) end, desc = "Telescope TODO grep", },
                --{ '<leader>pg', function() require 'telescope.builtin'.live_grep() end, desc = "Telescope live_grep" },

                -- TODO not sure how nice this is
                --{ '<leader>c', function() require 'telescope.builtin'.quickfix() end, desc = "Telescope Quickfix" },
                --{ '<leader>hc', require 'telescope.builtin'.quickfixhistory, desc = "Telescope quickfixhistory" },
            },
        config = function()
          --local actions = require("telescope.actions")
          local open_with_trouble = require("trouble.sources.telescope").open

          -- Use this to add more results without clearing the trouble list
          local add_to_trouble = require("trouble.sources.telescope").add

          local telescope = require("telescope")

          telescope.setup({
            defaults = {
              mappings = {
                i = { ["<C-T>"] = open_with_trouble },
                n = { ["<C-T>"] = open_with_trouble },
              },
            },
          })
        end,
      },
    '';
}
