local dap = require('dap')
local dapui = require('dapui')
require('nvim-dap-virtual-text').setup()
dapui.setup()

vim.api.nvim_set_keymap("n", "<leader>dt", ":lua require'dapui'.toggle()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", { noremap = true })
--vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require<CR>", { noremap = true })

--vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" })

--local dap, dapui =require("dap"),require("dapui")
dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end
--dap.listeners.before.event_terminated["dapui_config"]=function()
--  dapui.close()
--end
--dap.listeners.before.event_exited["dapui_config"]=function()
--  dapui.close()
--end


-- c, see https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}
--dap.adapters.cppdbg = {
--  id = 'cppdbg',
--  type = 'executable',
--  command = '/nix/store/m4g769whwylg57gycqccl5jq2avcpkdd-vscode-extension-ms-vscode-cpptools-1.17.3/share/vscode/extension/debugAdapters/bin/OpenDebugAD7',
--}
--dap.configurations.cpp = {
--  {
--    name = "Launch file",
--    type = "cppdbg",
--    request = "launch",
--    program = function()
--      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--    end,
--    cwd = '${workspaceFolder}',
--    stopAtEntry = true,
--  },
--  {
--    name = 'Attach to gdbserver :1234',
--    type = 'cppdbg',
--    request = 'launch',
--    MIMode = 'gdb',
--    miDebuggerServerAddress = 'localhost:1234',
--    miDebuggerPath = '/usr/bin/gdb',
--    cwd = '${workspaceFolder}',
--    program = function()
--      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--    end,
--  },
--}
--
--dap.configurations.c = dap.configurations.cpp
--dap.configurations.rust = dap.configurations.cpp
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}

-- go
require'dap-go'.setup()
