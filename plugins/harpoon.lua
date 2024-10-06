return {
    {
        "ThePrimeagen/harpoon",
        name = "harpoon2",
        branch = "harpoon2",
        opts = {},
        --config = function()
        --    local harpoon = require("harpoon")

        --    harpoon:setup()
        --end,
        -- stylua: ignore
        keys = {
            {
                "<C-e>",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Edit require 'harpoon' list",
            },
            { "<leader>a",     function() require("harpoon"):list():add() end,         desc = "Add to require 'harpoon' list", },
            { "<C-h>",         function() require("harpoon"):list():select(1) end,     desc = "Select 1", },
            { "<C-t>",         function() require("harpoon"):list():select(2) end,     desc = "Select 2", },
            { "<C-n>",         function() require("harpoon"):list():select(3) end,     desc = "Select 3", },
            { "<C-s>",         function() require("harpoon"):list():select(4) end,     desc = "Select 4", },
            { "<leader><C-h>", function() require("harpoon"):list():replace_at(1) end, desc = "Replace 1", },
            { "<leader><C-t>", function() require("harpoon"):list():replace_at(2) end, desc = "Replace 2", },
            { "<leader><C-n>", function() require("harpoon"):list():replace_at(3) end, desc = "Replace 3", },
            { "<leader><C-s>", function() require("harpoon"):list():replace_at(4) end, desc = "Replace 4", },
        },
    },
}
