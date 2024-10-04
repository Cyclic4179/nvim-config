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
    --{
    --    "folke/flash.nvim",
    --    -- i dont like it
    --    event = "VeryLazy",
    --    ---@type Flash.Config
    --    opts = {},
    --    -- stylua: ignore
    --    keys = {
    --        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    --        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    --        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    --        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    --    },
    --},
    --{
    --    "smoka7/hop.nvim",
    --    event = { "VeryLazy" },
    --    version = "*",
    --    opts = {
    --        keys = "etovxqpdygfblzhckisuran",
    --    },
    --},
    {
        "ggandor/leap.nvim",
        -- stylua: ignore
        keys = {
            { "s", function() require("leap").leap() end, mode = { "x", "n" }, desc = "Leap", },
        },
    },
    --{
    --    "windwp/nvim-autopairs",
    --    event = "InsertEnter",
    --    opts = {
    --        disable_filetype = { "TelescopePrompt" },
    --    },
    --},
    --{
    --    "norcalli/nvim-colorizer.lua",
    --    event = { "BufReadPre", "BufNewFile" },
    --    --config = true,
    --    opts = { '*', { lowercase = true, }, },
    --    --config = function()
    --    --    require 'colorizer'.setup({ lowercase = true, })
    --    --end
    --},
}
