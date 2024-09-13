return {
    {
        'ThePrimeagen/harpoon',
        name = "harpoon2",
        branch = "harpoon2",
        opts = {},
        --config = function()
        --    local harpoon = require("harpoon")

        --    harpoon:setup()
        --end,
        keys = {
            {
                "<leader>a",
                function() require 'harpoon':list():add() end,
                desc = "Add to require 'harpoon' list",
            },
            {
                "<C-e>",
                function()
                    local harpoon = require 'harpoon'
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Edit require 'harpoon' list",
            },
            {
                "<C-h>",
                function() require 'harpoon':list():select(1) end,
                desc = "",
            },
            {
                "<C-t>",
                function() require 'harpoon':list():select(2) end,
                desc = "",
            },
            {
                "<C-n>",
                function() require 'harpoon':list():select(3) end,
                desc = "",
            },
            {
                "<C-s>",
                function() require 'harpoon':list():select(4) end,
                desc = "",
            },
            {
                "<leader><C-h>",
                function() require 'harpoon':list():replace_at(1) end,
                desc = "",
            },
            {
                "<leader><C-t>",
                function() require 'harpoon':list():replace_at(2) end,
                desc = "",
            },
            {
                "<leader><C-n>",
                function() require 'harpoon':list():replace_at(3) end,
                desc = "",
            },
            {
                "<leader><C-s>",
                function() require 'harpoon':list():replace_at(4) end,
                desc = "",
            },
        },
    },
}
