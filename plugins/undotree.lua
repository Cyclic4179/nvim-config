return {
    {
        "mbbill/undotree",
        keys = {
            {
                "<leader>u",
                vim.cmd.UndotreeToggle,
            },
        },
        init = function()
            vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
            vim.opt.undofile = true
        end,
    },
}
