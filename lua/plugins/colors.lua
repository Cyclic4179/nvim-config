return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        lazy = false,
        config = function()
            -- using opts wont work here (:shrug:)
            require 'rose-pine'.setup {
                styles = { italic = false, transparency = true },
                --dim_inactive_windows = true,
                highlight_groups = {
                    Search = { bg = "#35314f", fg = "NONE", },
                    DapBreakpoint = { fg = "red" },
                    DapBreakpointCondition = { fg = "yellow" },
                    DapLogPoint = { fg = "iris" },
                    DapStopped = { bg = "#2d2c3f" },
                    DapStoppedSign = { bg = "#2d2c3f", fg = "red" },
                },
                -- overrides main palette
                palette = {
                    main = {
                        -- default text color is too bright for me
                        -- see https://coolors.co/gradient-palette/b3b1ad-e0def4?number=10
                        --text = "#B3B1AD",
                        --text = "#BDBBBD",
                        text = "#D1CFDC",
                        --text = "#CCCAD4",
                    },
                },
            }

            vim.cmd.colorscheme("rose-pine")
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end
    },
}
