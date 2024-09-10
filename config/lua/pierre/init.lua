require("pierre.remap")
require("pierre.set")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local rm_sp_write_group = augroup('RmTrailSpaces', {})
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

autocmd({ "BufWritePre" }, {
    group = rm_sp_write_group,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

--autocmd("BufRead", {
--    callback = function(ev)
--        if vim.bo[ev.buf].buftype == "quickfix" then
--            vim.schedule(function()
--                vim.cmd([[cclose]])
--                vim.cmd([[Trouble qflist open]])
--            end)
--        end
--    end,
--})

autocmd("QuickFixCmdPost", {
    callback = function()
        vim.cmd([[Trouble qflist open]])
    end,
})

-- yaml indentation fix
--autocmd("FileType", {
--    pattern = "yaml",
--    callback = function()
--    end,
--})

-- i use oil now
--vim.g.netrw_browse_split = 0
--vim.g.netrw_banner = 0
--vim.g.netrw_winsize = 25
