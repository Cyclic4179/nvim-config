return {
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "-",
                "<CMD>Oil<CR>",
                desc = "Open parent directory",
            },
        },
        --lazy = false,
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            --default_file_explorer = true,

            delete_to_trash = true,

            skip_confirm_for_simple_edits = true,

            view_options = {
                show_hidden = true,
                --natural_order = true, -- this is the default
                case_insensitive = false,
                is_always_hidden = function(name, _)
                    return name == '..'
                    -- or name == '.git'
                end,
            },

            win_options = {
                wrap = true,
            },

            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                --["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
                --["<C-h>"] = { "actions.select", opts = { vertical = true, split = "botright" }, desc = "Open the entry in a horizontal split" },
                --["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
                --["gd"] = function()
                --    require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                --end,
                -- not working for some reason
                --["<C-j>"] = { "actions.preview", opts = { vertical = true, split = "botright" }, desc = "Preview the entry in vertical split" },
                ["<C-j>"] = {
                    callback = function()
                        require("oil").open_preview({ vertical = true, split = "botright" })
                    end,
                    desc = "Preview the entry in vertical split"
                },
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            -- Set to false to disable all of the above keymaps
            use_default_keymaps = false,
        },
    }
}
