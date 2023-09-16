require("pierre.remap")
require("pierre.set")

local augroup = vim.api.nvim_create_augroup
local PierreGroup = augroup('Pierre', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

-- yank highlight
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = PierreGroup,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

-- yaml indentation fix
autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.cmd("setlocal indentkeys-=0#")
    end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
