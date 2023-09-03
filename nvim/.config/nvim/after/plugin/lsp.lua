local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
    'clangd',
    'dockerls',
    'docker_compose_language_service',
    'texlab',
	'tsserver',
	'eslint',
	'rust_analyzer',
    'pylsp',
    'lua_ls'
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
	vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
end)


-- lua fix unknown global vim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- pylsp better linting
require('lspconfig').pylsp.setup({
    settings = {
        pylsp = {
            configurationSources = { 'flake8' },
            plugins = {
                jedi_completion = { enabled = true },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true },
                pycodestyle = { enabled = false },
                flake8 = {
                    enabled = true,
                    maxLineLength = 160
                },
                mypy = { enabled = false },
                isort = { enabled = false },
                yapf = { enabled = false },
                pylint = { enabled = false },
                pydocstyle = { enabled = false },
                mccabe = { enabled = false },
                preload = { enabled = false },
                rope_completion = { enabled = false }
            }
        },
        pylspa  = {
            configurationSources  = { 'pycodestyle' },
            plugins  = {
                autopep8  = { enabled = true },
                flake8  = {
                    config  =nil,
                    enabled  = false,
                    exclude   = {},
                    executable  = 'flake8',
                    filename  = nil,
                    hangClosing  = nil,
                    ignore  = {},
                    maxComplexity  = nil,
                    maxLineLength  = nil,
                    indentSize  = nil,
                    perFileIgnores  = {},
                    select  = nil
                },
                jedi  = {
                    auto_import_modules  = { 'numpy' },
                    extra_paths  = {},
                    env_vars  = nil,
                    environment  = nil
                },
                jedi_completion  = {
                    enabled  = true,
                    include_params  = true,
                    include_class_objects  = false,
                    include_function_objects  = false,
                    fuzzy  = false,
                    eager  = false,
                    resolve_at_most  = 25,
                    cache_for  = { 'pandas', 'numpy', 'tensorflow', 'matplotlib' }
                },
                jedi_hover  = { enabled = true },
                jedi_references  = { enabled = true },
                jedi_signature_help  = { enabled = true },
                jedi_symbols  = { all_scopes = true, include_import_symbols = true },
                mccabe  = { enabled = true, threshold = 15 },
                preload  = { enabled = true, modules = {} },
                pycodestyle  = {
                    enabled  = true,
                    exclude  = {},
                    filename  = {},
                    select  = nil,
                    ignore  = {},
                    hangClosing  = nil,
                    maxLineLength  = nil,
                    indentSize  = nil
                },
                pydocstyle  = {
                    enabled  = false,
                    convention  = nil,
                    addIgnore  = {},
                    addSelect  = {},
                    ignore  = {},
                    select  = nil,
                    match  = '(?!test_).*\\.py',
                    matchDir  = '{^\\.}.*'
                },
                pyflakes  = { enabled = true },
                pylint  = { enabled = false, args = {}, executable = nil },
                rope_autoimport  = { enabled = false, memory = false },
                rope_completion  = { enabled = false, eager = false },
                yapf  = { enabled = true }
            },
            rope  = { extensionModules = nil, ropeFolder = nil }
        }
    }
})


lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
