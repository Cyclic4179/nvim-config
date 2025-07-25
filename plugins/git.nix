{ pkgs, ... }:
{
  binaries = with pkgs; [
  ];
  lazy =
    with pkgs.vimPlugins;
    # lua
    ''
      {
        -- "tpope/vim-fugitive",
        dir = "${vim-fugitive}",
        name = "vim-fugitive",
        cmd = { "Git", "G" },
        dependencies = {
          -- "nvim-neotest/nvim-nio", -- used for async git
          { dir = "${nvim-nio}", name = "nvim-nio" },
        },
        keys = {
          { "<leader>gs", vim.cmd.Git },
        },
        config = function()
          --vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

          local fugitive_group = vim.api.nvim_create_augroup("FugitiveGroup", {})

          vim.api.nvim_create_autocmd("BufWinEnter", {
            group = fugitive_group,
            pattern = "*",
            callback = function()
              if vim.bo.ft ~= "fugitive" then
                return
              end

              local bufnr = vim.api.nvim_get_current_buf()
              local opts = { buffer = bufnr, remap = false }
              vim.keymap.set("n", "<leader>p", function()
                --require("nio").run(function()
                vim.cmd([[ Git push ]])
                --end)
              end, opts)

              -- rebase always
              vim.keymap.set("n", "<leader>P", function()
                --require("nio").run(function()
                vim.cmd([[ Git pull --rebase ]])
                --end)
              end, opts)

              -- NOTE: It allows me to easily set the branch i am pushing and any tracking
              -- needed if i did not set the branch up correctly
              vim.keymap.set("n", "<leader>t", function()
                --require("nio").run(function()
                vim.cmd([[ Git push -u origin ]])
                --end)
              end, opts)
            end,
          })

          vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
          vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
        end,
      },
      -- copied from https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/plugins/editor.lua#L120-L179
      -- git signs highlights text that has changed since the list
      -- git commit, and also lets you interactively stage & unstage
      -- hunks in a commit.
      {
        "lewis6991/gitsigns.nvim",
        dir = "${gitsigns-nvim}",
        name = "gitsigns.nvim",
        event = "VeryLazy", --was LazyFile see https://github.com/LazyVim/LazyVim/discussions/1583
        opts = {
          signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
          },
          signs_staged = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
          },
          -- on_attach = function(buffer)
          --   local gs = package.loaded.gitsigns

          --   local function map(mode, l, r, desc)
          --     vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          --   end

          --   -- stylua: ignore start
          --   map("n", "]h", function()
          --     if vim.wo.diff then
          --       vim.cmd.normal({ "]c", bang = true })
          --     else
          --       gs.nav_hunk("next")
          --     end
          --   end, "Next Hunk")
          --   map("n", "[h", function()
          --     if vim.wo.diff then
          --       vim.cmd.normal({ "[c", bang = true })
          --     else
          --       gs.nav_hunk("prev")
          --     end
          --   end, "Prev Hunk")
          --   map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
          --   map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
          --   map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          --   map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          --   map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
          --   map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
          --   map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
          --   map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
          --   map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
          --   map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
          --   map("n", "<leader>ghd", gs.diffthis, "Diff This")
          --   map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
          --   map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
          -- end,
        },
      },
    '';
}
