-- Setup language servers.
local lspconfig = require('lspconfig')

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--    capabilities = capabilities
--}

--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- resolved by settings PYTHONPATH (https://jdhao.github.io/2023/07/22/neovim-pylsp-setup)
--local venv_path = os.getenv('VIRTUAL_ENV')
--local py_path = nil
---- decide which python executable to use for mypy
--if venv_path ~= nil then
--    py_path = venv_path .. "/bin/python3"
--else
--    py_path = vim.g.python3_host_prog
--end

lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                -- formatter options
                black = { enabled = true },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = true, executable = "pylint" },
                ruff = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = {
                    enabled = true,
                    --overrides = { "--python-executable", py_path, true },
                    report_progress = true,
                    live_mode = false
                },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                isort = { enabled = true },
            },
        },
    },
    flags = {
        debounce_text_changes = 200,
    },
    capabilities = capabilities,
}

--lspconfig.pylsp.setup {
--    capabilities = capabilities,
--    settings = {
--        pylsp = {
--            plugins = {
--                --ruff = {
--                --    enabled = true,
--                --    extendSelect = { "I" },
--                --    --lineLength = 160
--                --},
--                --mypy = {
--                --    enabled = false,
--                --    live_mode = true,
--                --    strict = true
--                --}
--            }
--        }
--    }
--}

lspconfig.ocamllsp.setup {}

--lspconfig.pyright.setup { capabilities = capabilities }
--lspconfig.jdtls.setup {
--    capabilities = capabilities,
--    cmd = { "jdt-language-server", "-data", home .. "/.cache/jdtls/workspace" },
--    root_dir = function(fname)
--		return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
--	end,
--}
--
--lspconfig.java_language_server.setup {
--    capabilities = capabilities,
--    cmd = { 'java-language-server' }
--}

lspconfig.tsserver.setup { capabilities = capabilities }
lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
        ['rust-analyzer'] = {},
    }
}
lspconfig.nil_ls.setup {
    capabilities = capabilities,
    autostart = true
}
lspconfig.clangd.setup { capabilities = capabilities }
lspconfig.dockerls.setup { capabilities = capabilities }
lspconfig.texlab.setup { capabilities = capabilities }
--lspconfig.pylsp.setup { capabilities = capabilities }
lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
lspconfig.gopls.setup {
    -- for postfix snippets and analyzers
    capabilities = capabilities,
    settings = {
        gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
        },
    },
}



-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float) -- kinda useless? (if on error just use [d or ]d
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set({ 'i', 'n' }, '<C-k>', vim.lsp.buf.signature_help, opts)
        --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        --vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        --vim.keymap.set('n', '<leader>wl', function()
        --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, opts)
        --vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
        --vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        --vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})


local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = true
})
