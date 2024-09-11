return {
    "nvim-tree/nvim-web-devicons",
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        lazy = false,
        opts = {
            styles = { italic = false, transparency = true },
            --dim_inactive_windows = true,
            highlight_groups = {
                --TelescopeBorder = { bg = "none" },
                --TelescopeNormal = { bg = "none" },
                --TelescopePromptNormal = { bg = "base" },
                --TelescopeResultsNormal = { bg = "none" },
                --TelescopeSelection = { bg = "base" },
                --TelescopeSelectionCaret = { bg = "rose" },

                -- transparent background
                --NormalNC = { bg = "none" },
                --Normal = { bg = "none" },
                --NormalFloat = { bg = "none" },

                -- didnt work
                --HarpoonBorder = { bg = "none" },

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
                    text = "#111111",
                    --text = "#CCCAD4",
                },
            },
        },
        config = function()
            vim.cmd.colorscheme("rose-pine")
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


            -- see https://vi.stackexchange.com/questions/39074/user-borders-around-lsp-floating-windows
            local _border = "rounded" -- none single double rounded solid shadow

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover, {
                    border = _border
                }
            )

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help, {
                    border = _border
                }
            )

            vim.diagnostic.config {
                float = { border = _border }
            }

            --require('lspconfig.ui.windows').default_options = {
            --    border = _border
            --}
        end
    },
}
