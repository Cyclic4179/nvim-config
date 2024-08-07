-- set icons
require("nvim-web-devicons").setup()

-- set theme
require("rose-pine").setup({
    styles = { italic = false, transparency = true },
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
})


--require("tokyonight").setup({
--    -- your configuration comes here
--    -- or leave it empty to use the default settings
--    style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
--    transparent = true, -- Enable this to disable setting the background color
--    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
--    styles = {
--        -- Style to be applied to different syntax groups
--        -- Value is any valid attr-list value for `:help nvim_set_hl`
--        comments = { italic = false },
--        keywords = { italic = false },
--        -- Background styles. Can be "dark", "transparent" or "normal"
--        sidebars = "dark", -- style for sidebars, see below
--        floats = "dark", -- style for floating windows
--    },
--})


vim.cmd.colorscheme("rose-pine")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })



-- background set transparent
--function ColorMyPencils(color)
--    color = color or "rose-pine"
--    vim.cmd.colorscheme(color)
--
--    --vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--    --vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--end
--
--ColorMyPencils()
