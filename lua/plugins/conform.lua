return {
    {
        "stevearc/conform.nvim",
        --event = { "BufReadPre", "BufNewFile" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require 'conform'.format({
                        lsp_fallback = true,
                        async = true,
                        timeout_ms = 500,
                    })
                end,
                mode = { "n", "v" },
                desc = "Format file or range (in visual mode)",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                svelte = { "prettierd", "prettier" },
                javascript = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                graphql = { "prettierd", "prettier" },
                java = { "google-java-format" },
                kotlin = { "ktlint" },
                ruby = { "standardrb" },
                markdown = { "prettierd", "prettier" },
                erb = { "htmlbeautifier" },
                html = { "htmlbeautifier" },
                bash = { "beautysh" },
                proto = { "buf" },
                rust = { "rustfmt" },
                yaml = { "yamlfix" },
                toml = { "taplo" },
                css = { "prettierd", "prettier" },
                scss = { "prettierd", "prettier" },
                nix = { "nixfmt" },
            },
        },
    },
}
