local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-P>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)


vim.keymap.set('n', '<leader>pt', function ()
    builtin.grep_string({ search = "TODO" })
end, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
