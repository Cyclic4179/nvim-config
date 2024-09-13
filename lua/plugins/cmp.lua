return {
    {
        "L3MON4D3/cmp-luasnip-choice",
        name = "cmp_luasnip_choice",
        lazy = true,
        config = function()
            require('cmp_luasnip_choice').setup({
                auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
            });
        end,
    },
    {
        'jmbuhr/otter.nvim',
        lazy = true,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {},
    },
    {
        "onsails/lspkind.nvim",
        name = "lspkind-nvim",
        lazy = true,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- vs-code like pictograms
            "onsails/lspkind.nvim",

            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/cmp-luasnip-choice",

            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",

            "hrsh7th/cmp-path",
            -- "FelipeLema/cmp-async-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-calc",

            "hrsh7th/cmp-cmdline",

            -- injected code
            'jmbuhr/otter.nvim',
            -- maybe this: https://github.com/petertriho/cmp-git
        },
        config = function()
            -- Not all LSP servers add brackets when completing a function.


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
                    { name = 'luasnip_choice' },
                    { name = 'calc' },
                    { name = 'nvim_lua' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                }, {
                    { name = 'async_path' },
                    { name = 'buffer',    keyword_length = 5 },
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
        end,
    }
}
