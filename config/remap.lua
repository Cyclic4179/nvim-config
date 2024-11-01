vim.g.mapleader = " "

-- https://github.com/folke/dot/blob/master/nvim/lua/config/options.lua ?
--local keymap_set = vim.keymap.set
--vim.keymap.set =

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Increment/decrement
--vim.keymap.set("n", "+", "<C-a>")
--vim.keymap.set("n", "-", "<C-x>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
--vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) -- i am using conform now

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gi<left><left><left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<cr>", { silent = true })

--vim.keymap.set("v", "\"", "")

-- if using this then <leader>s -> <leader>s
--vim.keymap.set("n", "<leader>sk", function()
--    return "<esc>v" .. vim.v.count1 .. "k" .. [[:s/\<<c-r><c-w>\>/<c-r><c-w>/gi<left><left><left>]]
--end, { expr = true })
--vim.keymap.set("n", "<leader>sj", function()
--    return "<esc>v" .. vim.v.count1 .. "j" .. [[:s/\<<c-r><c-w>\>/<c-r><c-w>/gi<left><left><left>]]
--end, { expr = true })

-- see https://jdhao.github.io/2019/04/29/nvim_map_with_a_count/
--vim.keymap.set("n", "<leader>o", function()
--    return "m`" .. vim.v.count1 .. "o<esc>``"
--end, { expr = true })
--vim.keymap.set("n", "<leader>O", function()
--    return "m`" .. vim.v.count .. "O<esc>``"
--end, { expr = true })

vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "gj", "j", { noremap = true })

vim.keymap.set("n", "[c", "<CMD>cnext<CR>")
vim.keymap.set("n", "]c", "<CMD>cprev<CR>")

-- maybe sometime
--vim.keymap.set('n', '[l', '<CMD>:lnext<CR>')
--vim.keymap.set('n', ']l', '<CMD>:lprev<CR>')

-- trying this out: (this sucks)
--vim.keymap.set("n", "<leader>h", "<cmd>set hlsearch!<cr>")
