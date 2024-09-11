return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_filetype = { "TelescopePrompt" },
        },
    },
    --{
    --    "nvim-treesitter/nvim-treesitter",
    --    event = { "BufReadPre", "BufNewFile" },
    --    opts = {
    --        highlight = {
    --            enable = true,
    --        },

    --        indent = {
    --            enable = true
    --        },

    --        --incremental_selection = {
    --        --    enable = true,
    --        --    keymaps = {
    --        --        init_selection = "gnn", -- set to `false` to disable one of the mappings
    --        --        node_incremental = "grn",
    --        --        scope_incremental = "grc",
    --        --        node_decremental = "grm",
    --        --    },
    --        --},
    --    },
    --    config = function ()
    --        print("loaded treesitter")
    --    end
    --},
    --{ "norcalli/nvim-colorizer.lua", config = true },
    --{
    --    "stevearc/conform.nvim",
    --    --event = { "BufReadPre", "BufNewFile" },
    --    keys = {
    --        "<leader>f",
    --        function()
    --            require 'conform'.format({
    --                lsp_fallback = true,
    --                async = true,
    --                timeout_ms = 500,
    --            })
    --        end,
    --        { "n", "v" },
    --        desc = "Format file or range (in visual mode)",
    --    },
    --    opts = {
    --        formatters_by_ft = {
    --            lua = { "stylua" },
    --            svelte = { { "prettierd", "prettier" } },
    --            javascript = { { "prettierd", "prettier" } },
    --            typescript = { { "prettierd", "prettier" } },
    --            javascriptreact = { { "prettierd", "prettier" } },
    --            typescriptreact = { { "prettierd", "prettier" } },
    --            json = { { "prettierd", "prettier" } },
    --            graphql = { { "prettierd", "prettier" } },
    --            java = { "google-java-format" },
    --            kotlin = { "ktlint" },
    --            ruby = { "standardrb" },
    --            markdown = { { "prettierd", "prettier" } },
    --            erb = { "htmlbeautifier" },
    --            html = { "htmlbeautifier" },
    --            bash = { "beautysh" },
    --            proto = { "buf" },
    --            rust = { "rustfmt" },
    --            yaml = { "yamlfix" },
    --            toml = { "taplo" },
    --            css = { { "prettierd", "prettier" } },
    --            scss = { { "prettierd", "prettier" } },
    --        },
    --    },
    --}
}
