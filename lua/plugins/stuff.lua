return {
    {
        "tzachar/local-highlight.nvim",
        event = { "BufRead" },
        opts = {
            --hlgroup = "Search",
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
    -- TODO: luasnippets (see https://github.com/L3MON4D3/Dotfiles/blob/master/.config/nvim/lua/plugins/luasnip/init.lua)
    -- TODO: dap
    -- TODO: java lsp
    -- TODO: word under cursor highlighting
}
