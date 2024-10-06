return {
    {
        -- see https://github.com/tzachar/local-highlight.nvim
        -- i think this is more annoying than useful
        "tzachar/local-highlight.nvim",
        event = { "BufRead" },
        opts = {
            --hlgroup = "Search",
            -- Whether to display highlights in INSERT mode or not
            --insert_mode = false,
            min_match_len = 5, -- default is 1
            --max_match_len = math.huge,
            --highlight_single_match = true,
        },
        init = function()
            vim.g.updatetime = 300
        end,
    },
    -- {
    --     -- doesnt work that great
    --     "jmbuhr/otter.nvim",
    --     event = "VeryLazy",
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     opts = {
    --         buffers = {
    --             set_filetype = true,
    --         },
    --     },
    -- },
    {
        "echasnovski/mini.ai",
        name = "mini.nvim",
        event = "VeryLazy",
        config = function()
            require("mini.ai").setup()
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            --triggers = {},
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        -- keys = {
        --     {
        --         "<leader>?",
        --         function()
        --             require("which-key").show({ global = false })
        --         end,
        --         desc = "Buffer Local Keymaps (which-key)",
        --     },
        -- },
    },
    -- {
    --     "folke/flash.nvim",
    --     -- i dont like it, adds / overwrites a lot of keymaps
    --     event = "VeryLazy",
    --     ---@type Flash.Config
    --     opts = {},
    --     -- stylua: ignore
    --     keys = {
    --         { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    --         { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    --         { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    --         { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --         { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    --     },
    -- },
    --{
    --    "smoka7/hop.nvim",
    --    event = { "VeryLazy" },
    --    version = "*",
    --    opts = {
    --        keys = "etovxqpdygfblzhckisuran",
    --    },
    --},
    --{
    --    -- did nothing, maybe wong setup?
    --    "tpope/vim-repeat",
    --    event = "VeryLazy",
    --},
    {
        -- leap is nice, but not sure if i dont overuse it
        "ggandor/leap.nvim",
        event = "VeryLazy",
        -- stylua: ignore
        --keys = {
        --    -- buggy, see https://github.com/LazyVim/LazyVim/issues/2379
        --    { "s", function() require("leap").leap() end, mode = { "x", "n" }, desc = "Leap", },
        --},
        config = function()
            local leap = require("leap")
            leap.opts.case_sensitive = true

            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
            vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
            vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
        end,
    },
    --{
    --    -- doesnt highlight in insert_mode
    --    "brenoprata10/nvim-highlight-colors",
    --    event = "VeryLazy",
    --    opts = {},
    --},
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        --opts = {
        --    disable_filetype = { "TelescopePrompt" },
        --},
        config = function()
            require("nvim-autopairs").setup({
                disable_filetype = { "TelescopePrompt", "oil" },
                -- disable_in_macro = true, -- disable when recording or executing a macro
                -- disable_in_visualblock = false, -- disable when insert after visual block mode
                -- disable_in_replace_mode = true,
                -- ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
                -- enable_moveright = true,
                -- enable_afterquote = true, -- add bracket pairs after quote
                -- enable_check_bracket_line = true, --- check bracket in same line
                -- enable_bracket_in_quote = true, --
                -- enable_abbr = false, -- trigger abbreviation
                -- break_undo = true, -- switch for basic rule break undo sequence
                check_ts = true,
                -- map_cr = true,
                -- map_bs = true, -- map the <BS> key
                -- map_c_h = false, -- Map the <C-h> key to delete a pair
                -- map_c_w = false, -- map <c-w> to delete a pair if possible
            })

            local Rule = require("nvim-autopairs.rule")
            local npairs = require("nvim-autopairs")

            -- cool
            npairs.add_rule(Rule("$$", "$$", "tex"))
            -- npairs.add_rule(Rule("\\[", "\\]", "tex"))
            -- npairs.add_rule(Rule("\\(", "\\)", "tex"))

            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        -- also unmaintained, but more recent
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            user_default_options = {
                -- RGB = true, -- #RGB hex codes
                -- RRGGBB = true, -- #RRGGBB hex codes
                -- names = true, -- "Name" codes like Blue or blue
                -- RRGGBBAA = false, -- #RRGGBBAA hex codes
                -- AARRGGBB = false, -- 0xAARRGGBB hex codes
                -- rgb_fn = false, -- CSS rgb() and rgba() functions
                -- hsl_fn = false, -- CSS hsl() and hsla() functions
                -- css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                -- css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "virtualtext", -- Set the display mode.
                -- Available methods are false / true / "normal" / "lsp" / "both"
                -- True is same as normal
                -- tailwind = false, -- Enable tailwind colors
                -- parsers can contain values used in |user_default_options|
                -- sass = { enable = false, parsers = { css } }, -- Enable sass colors
                -- virtualtext = "■",
                -- virtualtext_inline = false, -- Show the virtualtext inline with the color
                -- update color values even if buffer is not focused
                -- always_update = false,
            },
        },
    },
    -- {
    --     -- unmaintained
    --     "norcalli/nvim-colorizer.lua",
    --     event = { "BufReadPre", "BufNewFile" },
    --     --config = true,
    --     opts = { "*", "oil", { lowercase = true } },
    --     --config = function()
    --     --    require 'colorizer'.setup({ lowercase = true, })
    --     --end
    -- },
}
