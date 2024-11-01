local current_trouble_mode

return {
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        -- stylua: ignore
        keys = {
            -- "<cmd>Trouble diagnostics toggle<cr>"
            { "<leader>tt", function()
                require("trouble").toggle({ mode = "diagnostics" })
                current_trouble_mode = "diagnostics"
            end, desc = "Diagnostics (Trouble)", },

            -- "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"
            { "<leader>tT", function()
                require("trouble").toggle({ mode = "diagnostics" })
                current_trouble_mode = "diagnostics"
            end, desc = "Buffer Diagnostics (Trouble)", },

            -- "<cmd>Trouble symbols toggle focus=false<cr>"
            { "<leader>ts", function()
                require("trouble").toggle({ mode = "symbols", focus = false })
                current_trouble_mode = "symbols"
            end, desc = "Symbols (Trouble)", },

            -- "<cmd>Trouble lsp toggle focus=false win.position=right<cr>"
            { "<leader>tL", function()
                require("trouble").toggle({ mode = "lsp", focus = false, win = { position = "right" } })
                current_trouble_mode = "lsp"
            end, desc = "LSP Definitions / references / ... (Trouble)", },

            -- "<cmd>Trouble loclist toggle<cr>"
            { "<leader>tl", function()
                require("trouble").toggle({ mode = "loclist" })
                current_trouble_mode = "loclist"
            end, desc = "Location List (Trouble)", },

            -- "<cmd>Trouble qflist toggle<cr>"
            { "<leader>tc", function()
                require("trouble").toggle({ mode = "qflist" })
                current_trouble_mode = "qflist"
            end, desc = "Quickfix List (Trouble)", },

            --{ "<leader>tt", function() require("trouble").toggle() end, desc = "Trouble toggle" },
            { "<leader>tm", function()
                require("trouble").toggle({ mode = current_trouble_mode })
            end, desc = "Toggle last mode (Trouble)", },

            { "[t", function()
                require("trouble").next({ mode = current_trouble_mode, skip_groups = true, jump = true })
            end, desc = "Next (Trouble)", },
            { "]t", function()
                require("trouble").previous({ mode = current_trouble_mode, skip_groups = true, jump = true })
            end, desc = "Previous (Trouble)", },
        },
    },
}
