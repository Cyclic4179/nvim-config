return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            max_lines = 5,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        --lazy = false,
        config = function()
            vim.opt.rtp:prepend(vim.g.TREESITTER_PARSER_PATH)
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },

                indent = {
                    enable = true,
                },

                --incremental_selection = {
                --    enable = true,
                --    keymaps = {
                --        init_selection = "gnn", -- set to `false` to disable one of the mappings
                --        node_incremental = "grn",
                --        scope_incremental = "grc",
                --        node_decremental = "grm",
                --    },
                --},
                parser_install_dir = vim.g.TREESITTER_PARSER_PATH,
            })
        end,
    },
}
