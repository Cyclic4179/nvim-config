local builtin = require('telescope.builtin')


---- We cache the results of "git rev-parse"
---- Process creation is expensive in Windows, so this reduces latency
--local is_inside_work_tree = {}
--
--local project_files = function()
--  local opts = {} -- define here if you want to define something
--
--  local cwd = vim.fn.getcwd()
--  if is_inside_work_tree[cwd] == nil then
--    vim.fn.system("git rev-parse --is-inside-work-tree")
--    is_inside_work_tree[cwd] = vim.v.shell_error == 0
--  end
--
--  if is_inside_work_tree[cwd] then
--    builtin.git_files(opts)
--  else
--    builtin.find_files(opts)
--  end
--end


vim.keymap.set('n', '<leader>pf', builtin.find_files)
vim.keymap.set('n', '<C-P>', builtin.git_files)
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)



vim.keymap.set('n', '<leader>pt', function()
    builtin.grep_string({ search = "TODO" })
end, {})
--vim.keymap.set('n', '<leader>pg', builtin.live_grep)


-- TODO not sure how nice this is
vim.keymap.set('n', '<leader>c', builtin.quickfix)
vim.keymap.set('n', '<leader>hc', builtin.quickfixhistory)
vim.keymap.set('n', '[c', '<CMD>:cnext<CR>')
vim.keymap.set('n', ']c', '<CMD>:cprev<CR>')

-- maybe sometime
--vim.keymap.set('n', '[l', '<CMD>:lnext<CR>')
--vim.keymap.set('n', ']l', '<CMD>:lprev<CR>')
