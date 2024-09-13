return {
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>tt",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            --{
            --    "<leader>tT",
            --    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            --    desc = "Buffer Diagnostics (Trouble)",
            --},
            {
                "<leader>ts",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>tL",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>tl",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>tc",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
            --{
            --    "<leader>tt",
            --    function()
            --        require("trouble").toggle()
            --    end,
            --    desc = "Trouble toggle",
            --},
            {
                "[t",
                function()
                    require("trouble").next({ skip_groups = true, jump = true })
                end,
            },
            {
                "]t",
                function()
                    require("trouble").previous({ skip_groups = true, jump = true })
                end,
            },
        },
    }
}
