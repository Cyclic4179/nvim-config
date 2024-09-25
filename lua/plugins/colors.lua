return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        lazy = false,
        config = function()
            -- using opts wont work here (:shrug:)
            require("rose-pine").setup({
                styles = { italic = false, transparency = true },
                --dim_inactive_windows = true,
                highlight_groups = {
                    -- used by local-highlight.nvim
                    -- see https://coolors.co/gradient-palette/293342-1f1d2e?number=10 and https://coolors.co/393555 and https://coolors.co/1f1d2e
                    -- other color options are: #241D28, #1F1D2E, #35314F
                    LocalHighlight = { bg = "#232737", fg = "NONE" },

                    DapBreakpoint = { fg = "red" },
                    DapBreakpointCondition = { fg = "yellow" },
                    DapLogPoint = { fg = "iris" },
                    DapStopped = { bg = "#2d2c3f" },
                    DapStoppedSign = { bg = "#2d2c3f", fg = "red" },

                    TreesitterContext = { bg = "#26233A" },
                    TreesitterContextLineNumber = { bg = "#26233A" },
                },
                -- overrides main palette
                palette = {
                    main = {
                        -- default text color is too bright for me
                        -- see https://coolors.co/gradient-palette/b3b1ad-e0def4?number=10
                        -- other options are: #B3B1AD, #BDBBBD, #CCCAD4
                        text = "#D1CFDC",
                    },
                },
            })

            vim.cmd.colorscheme("rose-pine")
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

            local override_border = function(config)
                -- idk why this works as i want it maybe FIXME in future
                if config and config.border then -- override border if set
                    config.border = "rounded"
                end
                return config
            end
            local local_nvim_open_win = vim.api.nvim_open_win
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.api.nvim_open_win = function(buffer, enter, config)
                return local_nvim_open_win(buffer, enter, override_border(config))
            end
            local local_nvim_win_set_config = vim.api.nvim_win_set_config
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.api.nvim_win_set_config = function(window, config)
                return local_nvim_win_set_config(window, override_border(config))
            end
        end,
    },
}
