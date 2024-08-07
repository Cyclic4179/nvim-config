local lspkind = require('lspkind')

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },

    mapping = {
        -- to test
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-e>'] = cmp.mapping.close(),

        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Insert
        }),
        ['<C-r>'] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
        }),
        ['<C-Space>'] = cmp.mapping.complete(),

        -- not use tab
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil
    },

    sources = cmp.config.sources({
        { name = 'calc' },
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
    }, {
        { name = 'path' },
        { name = 'buffer', keyword_length = 5 },
    }),

    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
                calc = "[calc]",
            },
        },
    },

    experimental = {
        -- Let's play with this for a day or two
        ghost_text = true,
    },
})


-- `/` cmdline setup.
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer', keyword_length = 2 }
    }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            },
            keyword_length = 2
        }
    })
})

vim.keymap.set('c', '<tab>', '<C-z>', { silent = false }) -- to fix cmp https://github.com/hrsh7th/nvim-cmp/issues/1511
