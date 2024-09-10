require 'trouble'.setup {
    modes = {
        test = {
            mode = "diagnostics",
            preview = {
                type = "split",
                relative = "win",
                position = "right",
                size = 0.3,
            },
        },
    },
}

vim.keymap.set("n", "<leader>tt", function()
    require("trouble").toggle()
end)

vim.keymap.set("n", "[t", function()
    require("trouble").next({ skip_groups = true, jump = true });
end)

vim.keymap.set("n", "]t", function()
    require("trouble").previous({ skip_groups = true, jump = true });
end)
