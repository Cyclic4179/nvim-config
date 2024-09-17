local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local pierre_group = augroup('Pierre', {})
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
    group = pierre_group,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

-- autocmd("BufRead", {
--     callback = function(ev)
--         if vim.bo[ev.buf].buftype == "quickfix" then
--             vim.schedule(function()
--                 vim.cmd([[cclose]])
--                 vim.cmd([[Trouble qflist open]])
--             end)
--         end
--     end,
-- })

autocmd("QuickFixCmdPost", {
    group = pierre_group,
    callback = function()
        vim.cmd([[Trouble qflist open]])
    end,
})


autocmd('LspAttach', {
    group = pierre_group,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)

        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

        -- not used
        -- vim.keymap.set({ 'i', 'n' }, '<C-k>', vim.lsp.buf.signature_help, opts)
        -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        -- vim.keymap.set('n', '<leader>wl', function()
        --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

        -- replaced by conform
        -- vim.keymap.set('n', '<leader>f', function()
        --     vim.lsp.buf.format { async = true }
        -- end, opts)
    end
})


autocmd("FileType", {
    pattern = "makefile",
    group = pierre_group,
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

autocmd("FileType", {
    pattern = "nix",
    group = pierre_group,
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

autocmd("FileType", {
    pattern = "yaml",
    group = pierre_group,
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.cmd("setlocal indentkeys-=0#")
    end,
})

autocmd("FileType", {
    pattern = "tex",
    group = pierre_group,
    callback = function()
        vim.opt_local.wrap = true
    end,
})
