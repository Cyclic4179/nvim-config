local dap = require('dap')
local dapui = require('dapui')
require('nvim-dap-virtual-text').setup{}
dapui.setup()


--vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
--vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#555530" })
--vim.api.nvim_set_hl(0, "DapStopped", { bg = "#474656" })
--vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" })
local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})
sign('DapStopped', { text='→', texthl='DapStoppedSign', linehl='DapStopped', numhl= 'DapStopped' })



vim.keymap.set("n", "<leader>dt", function() require'dapui'.toggle() end)
--vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
--vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>")
vim.keymap.set("n", "<leader>ds", function() require('dapui').open({reset = true}) end)

vim.keymap.set('n', '<Leader>df', function() require('dap').focus_frame() end)
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
--vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
--  require('dap.ui.widgets').hover()
--end)
--vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
--  require('dap.ui.widgets').preview()
--end)
--vim.keymap.set('n', '<Leader>df', function()
--  local widgets = require('dap.ui.widgets')
--  widgets.centered_float(widgets.frames)
--end)
--vim.keymap.set('n', '<Leader>ds', function()
--  local widgets = require('dap.ui.widgets')
--  widgets.centered_float(widgets.scopes)
--end)


--local dap, dapui =require("dap"),require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
--dap.listeners.before.event_terminated["dapui_config"]=function()
--  dapui.close()
--end
--dap.listeners.before.event_exited["dapui_config"]=function()
--  dapui.close()
--end


-- c, see https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.gdb = function (cb, cfg)
  local gdb_args = { "-i", "dap", "--args", cfg.program }
  cb {
    type = "executable",
    command = "gdb",
    args = vim.list_extend(gdb_args, cfg.xxx_program_args or {})
  }
end
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
      return coroutine.create(function(dap_run_co)
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local opts = {}
        pickers
          .new(opts, {
            prompt_title = "Path to executable",
            finder = finders.new_oneshot_job(
              { "fd", "--hidden", "--exclude", ".git", "--no-ignore", "--type", "x", "--color", "never" },
              {}
            ),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(buffer_number)
              actions.select_default:replace(function()
                actions.close(buffer_number)
                coroutine.resume(dap_run_co, action_state.get_selected_entry()[1])
              end)
              return true
            end,
          })
          :find()
      end)
    end,
    -- xxx is prepended -> first asked for program, then for arguments
    xxx_program_args = function()
      return vim.split(vim.fn.input('args: ', '', 'file'), ' ', {trimempty = true})
    end,
    --program = function()
    --  local actions = require "telescope.actions"
    --  local action_state = require "telescope.actions.state"
    --  require 'telescope.builtin'.find_files({
    --    title = "Choose executable",
    --    no_ignore = true,
    --    find_command = { "fd", "--type", "x", "--color", "never", },
    --    attach_mappings = function(prompt_bufnr, map)
    --      actions.select_default:replace(function()
    --        actions.close(prompt_bufnr)
    --        -- print(vim.inspect(selection))
    --        --vim.api.nvim_put({ selection[1] }, "", false, true)
    --      end)
    --      return true
    --    end,
    --  })
    --  return action_state.get_selected_entry()
    --  --return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

-- go
require 'dap-go'.setup()


--local s = "test \"nice\\ \""
--local x = vim.split(s, " ", { trimempty = true })
--
--local function a()
--  for y in vim.gsplit(s, ' ', { trimempty = true }) do
--    print(y)
--  end
--end
--
--t = {}
--s = "from=world, to=Lua"
--for k, v in string.gmatch(s, "(%w+)=(%w+)") do
--  t[k] = v
--end
--print(vim.inspect(t))
--
----a()
--
--print(vim.inspect(x))
