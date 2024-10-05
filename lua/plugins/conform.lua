return {
    {
        "stevearc/conform.nvim",
        --event = { "BufReadPre", "BufNewFile" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({
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
                --svelte = { "prettierd", "prettier" },
                --javascript = { "prettierd", "prettier" },
                --typescript = { "prettierd", "prettier" },
                --javascriptreact = { "prettierd", "prettier" },
                --typescriptreact = { "prettierd", "prettier" },
                --json = { "prettierd", "prettier" },
                --graphql = { "prettierd", "prettier" },
                --java = { "google-java-format" },
                --kotlin = { "ktlint" },
                --ruby = { "standardrb" },
                --markdown = { "prettierd", "prettier" },
                --erb = { "htmlbeautifier" },
                --html = { "htmlbeautifier" },
                --bash = { "beautysh" },
                --proto = { "buf" },
                --rust = { "rustfmt" },
                --yaml = { "yamlfix" },
                --toml = { "taplo" },
                --css = { "prettierd", "prettier" },
                --scss = { "prettierd", "prettier" },
                nix = { "nixfmt" },
                ocaml = { "ocamlformat" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                ["*"] = { "injected" },
            },
            formatters = {
                stylua = {
                    prepend_args = {
                        "--indent-type",
                        "Spaces",
                        "--indent-width",
                        "4",
                    },
                },
                ocamlformat = {
                    -- see `man ocamlformat` or https://ocaml.org/p/ocamlformat/latest/doc/index.html
                    prepend_args = {
                        "-p",
                        "janestreet",
                        "--type-decl-indent=4",
                        "--max-indent=8",
                        "--let-binding-indent=4",
                        "--function-indent=4",
                        "--extension-indent=4",
                        "--let-binding-spacing=sparse",
                        "--cases-exp-indent=4",
                    },
                },
                ["clang-format"] = {
                    -- see https://clang.llvm.org/docs/ClangFormat.html
                    -- (whole opts ref: https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
                    prepend_args = {
                        "--style={BasedOnStyle: google, \z
                        IndentWidth: 4, \z
                        ColumnLimit: 90, \z
                        AlignArrayOfStructures: Left, \z
                        AlignConsecutiveAssignments: { Enabled: true }, \z
                        AlignConsecutiveBitFields: { Enabled: true }, \z
                        AlignConsecutiveMacros: { Enabled: true }, \z
                        AlignOperands: true, \z
                        PenaltyBreakComment: 10000, \z
                        PenaltyBreakScopeResolution: 100, \z
                        PenaltyBreakBeforeFirstCallParameter: 10, \z
                        PenaltyExcessCharacter: 3, \z
                        BreakBeforeBinaryOperators: NonAssignment, \z
                        BreakConstructorInitializers: BeforeComma, \z
                        SpaceAfterCStyleCast: true}",
                    },
                },
                injected = {
                    options = {
                        -- Set to true to ignore errors
                        ignore_errors = false,
                        -- Map of treesitter language to file extension
                        -- A temporary file name with this extension will be generated during formatting
                        -- because some formatters care about the filename.
                        lang_to_ext = {
                            bash = "sh",
                            c_sharp = "cs",
                            elixir = "exs",
                            javascript = "js",
                            julia = "jl",
                            latex = "tex",
                            markdown = "md",
                            python = "py",
                            ruby = "rb",
                            rust = "rs",
                            teal = "tl",
                            r = "r",
                            typescript = "ts",
                        },
                        -- Map of treesitter language to formatters to use
                        -- (defaults to the value from formatters_by_ft)
                        lang_to_formatters = {},
                    },
                },
            },
        },
    },
}
