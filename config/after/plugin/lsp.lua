-- Setup language servers.
local lspconfig = require('lspconfig')

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--    capabilities = capabilities
--}

--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lspconfig.pylsp.setup {
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                ruff = {
                    enabled = true,
                    extendSelect = { "I" },
                    --lineLength = 160
                },
                --mypy = {
                --    enabled = false,
                --    live_mode = true,
                --    strict = true
                --}
            }
        }
    }
}

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


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
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
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        --vim.keymap.set({ 'i', 'n' }, '<C-h>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})













--local lsp = require('lsp-zero')
--
--lsp.preset('recommended')
--
--lsp.ensure_installed({
--    'clangd',
--    'dockerls',
--    'docker_compose_language_service',
--    'texlab',
--    'tsserver',
--    'eslint',
--    'rust_analyzer',
--    'pylsp',
--    'lua_ls'
--})

--lsp.setup_nvim_cmp({
--    mapping = cmp_mappings
--})


--lsp.set_preferences({
--    suggest_lsp_servers = false,
--    sign_icons = {
--        error = 'E',
--        warn = 'W',
--        hint = 'H',
--        info = 'I'
--    }
--})

local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

--lsp.on_attach(function(client, bufnr)
--    local opts = {buffer = bufnr, remap = false}
--
--    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
--    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
--    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
--    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
--    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
--    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
--    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
--    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
--
--end)


--lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})


require('isabelle-lsp').setup({})
lspconfig.isabelle.setup({
    capabilities = capabilities,
})

local luasnip = require'luasnip'
local s = luasnip.snippet
local sn = luasnip.snippet_node
local isn = luasnip.indent_snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node
local events = require('luasnip.util.events')
local ai = require('luasnip.nodes.absolute_indexer')
local extras = require('luasnip.extras')
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require('luasnip.extras.expand_conditions')
local postfix = require('luasnip.extras.postfix').postfix
local types = require('luasnip.util.types')
local parse = require('luasnip.util.parser').parse_snippet
local ms = luasnip.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key

local function copy(args)
    return args[1]
end

luasnip.add_snippets('isabelle', {
    -- arrows
    s('\\Implies', { t('\\<Longrightarrow>') }),
    s('\\implies', { t('\\<longrightarrow>') }),
    s('\\To', { t('\\<Rightarrow>') }),
    s('\\to', { t('\\<rightarrow>') }),
    s('\\Iff', { t('\\<Longleftrightarrow>') }),
    s('\\iff', { t('\\<longleftrightarrow>') }),

    s('\\leftarrow', { t('\\<leftarrow>') }),
    s('\\longleftarrow', { t('\\<longleftarrow>') }),
    s('\\longlongleftarrow', { t('\\<longlongleftarrow>') }),
    s('\\longlonglongleftarrow', { t('\\<longlonglongleftarrow>') }),
    s('\\rightarrow', { t('\\<rightarrow>') }),
    s('\\longrightarrow', { t('\\<longrightarrow>') }),
    s('\\longlongrightarrow', { t('\\<longlongrightarrow>') }),
    s('\\longlonglongrightarrow', { t('\\<longlonglongrightarrow>') }),
    s('\\Leftarrow', { t('\\<Leftarrow>') }),
    s('\\Longleftarrow', { t('\\<Longleftarrow>') }),
    s('\\Lleftarrow', { t('\\<Lleftarrow>') }),
    s('\\Rightarrow', { t('\\<Rightarrow>') }),
    s('\\Longrightarrow', { t('\\<Longrightarrow>') }),
    s('\\Rrightarrow', { t('\\<Rrightarrow>') }),
    s('\\leftrightarrow', { t('\\<leftrightarrow>') }),
    s('\\longleftrightarrow', { t('\\<longleftrightarrow>') }),
    s('\\Leftrightarrow', { t('\\<Leftrightarrow>') }),
    s('\\Longleftrightarrow', { t('\\<Longleftrightarrow>') }),
    s('\\mapsto', { t('\\<mapsto>') }),
    s('\\longmapsto', { t('\\<longmapsto>') }),

    s('\\down', { t('\\<down>') }),
    s('\\Down', { t('\\<Down>') }),
    s('\\up', { t('\\<up>') }),
    s('\\Up', { t('\\<Up>') }),

    -- logic
    s('\\and', { t('\\<and>') }),
    s('\\And', { t('\\<And>') }),
    s('\\or', { t('\\<or>') }),
    s('\\Or', { t('\\<Or>') }),
    s('\\forall', { t('\\<forall>') }),
    s('\\exists', { t('\\<exists>') }),
    s('\\nexists', { t('\\<nexists>') }),
    s('\\not', { t('\\<not>') }),
    s('\\oplus', { t('\\<oplus>') }),

    -- sets
    s('\\in', { t('\\<in>') }),
    s('\\notin', { t('\\<notin>') }),
    s('\\subset', { t('\\<subset>') }),
    s('\\supset', { t('\\<supset>') }),
    s('\\subseteq', { t('\\<subseteq>') }),
    s('\\supseteq', { t('\\<supseteq>') }),
    s('\\inter', { t('\\<inter>') }),
    s('\\Inter', { t('\\<Inter>') }),
    s('\\union', { t('\\<union>') }),
    s('\\Union', { t('\\<Union>') }),
    s('\\emptyset', { t('\\<emptyset>') }),

    -- lattice shit
    s('\\sqinter', { t('\\<sqinter>') }),
    s('\\Sqinter', { t('\\<Sqinter>') }),
    s('\\squnion', { t('\\<squnion>') }),
    s('\\Squnion', { t('\\<Squnion>') }),

    s('\\glb', { t('\\<sqinter>') }),
    s('\\Glb', { t('\\<Sqinter>') }),
    s('\\lub', { t('\\<squnion>') }),
    s('\\Lub', { t('\\<Squnion>') }),

    s('\\meet', { t('\\<sqinter>') }),
    s('\\Meet', { t('\\<Sqinter>') }),
    s('\\join', { t('\\<squnion>') }),
    s('\\Join', { t('\\<Squnion>') }),

    s('\\top', { t('\\<top>') }),
    s('\\bottom', { t('\\<bottom>') }),

    -- relations
    s('\\noteq', { t('\\<noteq>') }),
    s('\\neq', { t('\\<noteq>') }),
    s('\\le', { t('\\<le>') }),
    s('\\ge', { t('\\<ge>') }),
    s('\\sim', { t('\\<sim>') }),
    s('\\equiv', { t('\\<equiv>') }),
    s('\\lessapprox', { t('\\<lessapprox>') }),

    -- brackets
    s('\\open', { t('\\<open>') }),
    s('\\close', { t('\\<close>') }),
    s('\\lbrakk', { t('\\<lbrakk>') }),
    s('\\rbrakk', { t('\\<rbrakk>') }),

    -- greek symbols
    s('\\alpha', { t('\\<alpha>') }),
    s('\\beta', { t('\\<beta>') }),
    s('\\Gamma', { t('\\<Gamma>') }),
    s('\\tau', { t('\\<tau>') }),

    s('\\alpha', { t('\\<alpha>') }),
    s('\\beta', { t('\\<beta>') }),
    s('\\gamma', { t('\\<gamma>') }),
    s('\\delta', { t('\\<delta>') }),
    s('\\epsilon', { t('\\<epsilon>') }),
    s('\\zeta', { t('\\<zeta>') }),
    s('\\eta', { t('\\<eta>') }),
    s('\\theta', { t('\\<theta>') }),
    s('\\iota', { t('\\<iota>') }),
    s('\\kappa', { t('\\<kappa>') }),
    s('\\lambda', { t('\\<lambda>') }),
    s('\\mu', { t('\\<mu>') }),
    s('\\nu', { t('\\<nu>') }),
    s('\\xi', { t('\\<xi>') }),
    s('\\pi', { t('\\<pi>') }),
    s('\\rho', { t('\\<rho>') }),
    s('\\sigma', { t('\\<sigma>') }),
    s('\\tau', { t('\\<tau>') }),
    s('\\upsilon', { t('\\<upsilon>') }),
    s('\\phi', { t('\\<phi>') }),
    s('\\chi', { t('\\<chi>') }),
    s('\\psi', { t('\\<psi>') }),
    s('\\omega', { t('\\<omega>') }),
    s('\\Gamma', { t('\\<Gamma>') }),
    s('\\Delta', { t('\\<Delta>') }),
    s('\\Theta', { t('\\<Theta>') }),
    s('\\Lambda', { t('\\<Lambda>') }),
    s('\\Xi', { t('\\<Xi>') }),
    s('\\Pi', { t('\\<Pi>') }),
    s('\\Sigma', { t('\\<Sigma>') }),
    s('\\Upsilon', { t('\\<Upsilon>') }),
    s('\\Phi', { t('\\<Phi>') }),
    s('\\Psi', { t('\\<Psi>') }),
    s('\\Omega', { t('\\<Omega>') }),

    -- other symbols
    s('\\turnstile', { t('\\<turnstile>') }),
    s('\\Turnstile', { t('\\<Turnstile>') }),
    s('\\stileturn', { t('\\<stileturn>') }),
    s('\\circ', { t('\\<circ>') }),
    s('\\dots', { t('\\<dots>') }),
    s('\\times', { t('\\<times>') }),
    s('\\infinity', { t('\\<infinity>') }),

    s('\\bar', { t('\\<bar>') }),

    -- numbers
    s('\\sub', { t('\\<^sub>') }),
    s('\\bsub', { t('\\<^bsub>') }),
    s('\\esub', { t('\\<^esub>') }),

    s('\\sup', { t('\\<^sup>') }),
    s('\\bsup', { t('\\<^bsup>') }),
    s('\\esup', { t('\\<^esup>') }),

    -- isabelle keywords
    s('simp', { t('simp') }),
    s('auto', { t('auto') }),
    s('force', { t('force') }),
    s('fastforce', { t('fastforce') }),
    s('blast', { t('blast') }),
    s('try0', { t('try0') }),
    s('sledgehammer', { t('sledgehammer') }),

    s('fun', {
        t('fun '),
        i(1),
        t(' :: "'),
        i(2),
        t({ '" where', '\t"' }),
        f(copy, 1),
        t(' '),
        i(3, '_'),
        t(' = '),
        i(4, 'undefined'),
        t('"'),
    }),
    s('inductive', {
        t('inductive '),
        i(1),
        t(' :: "'),
        i(2),
        t({ '" where', '\t"' }),
        i(3),
        t('"'),
    }),
    s('proof', {
        t('proof ('),
        i(1, 'induction'),
        t({ ')', '\t' }),
        i(2),
        t({ '', 'qed' }),
    }),
})
