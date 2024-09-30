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
