local dap = require('dap')
local dapui = require('dapui')
require('nvim-dap-virtual-text').setup {}
dapui.setup()


--vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
--vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#555530" })
--vim.api.nvim_set_hl(0, "DapStopped", { bg = "#474656" })
--vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" })
local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
sign('DapStopped', { text = '→', texthl = 'DapStoppedSign', linehl = 'DapStopped', numhl = 'DapStopped' })



vim.keymap.set("n", "<leader>dt", function() require 'dapui'.toggle() end)
--vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
--vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>")
vim.keymap.set("n", "<leader>ds", function() require('dapui').open({ reset = true }) end)

vim.keymap.set('n', '<Leader>df', function() require('dap').focus_frame() end)
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp',
    function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
--vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)


-- Run last: https://github.com/mfussenegger/nvim-dap/issues/1025
local last_config = nil
dap.listeners.after.event_initialized["store_config"] = function(session)
  last_config = session.config
end

local function debug_run_last()
  if last_config then
    dap.run(last_config)
  else
    dap.continue()
  end
end

vim.keymap.set('n', '<Leader>dl', function()
    debug_run_last()
end)



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
dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "--quiet", "--interpreter=dap" },
    enrich_config = function(config, on_config)
      local final_config = vim.deepcopy(config)
      final_config.program = config[1]
      final_config.args = config[2]
      on_config(final_config)
    end,
    --enrichConfig = function(cfg, cb)
    --    cfg.args = cfg.xxx_program_args
    --    cb(cfg)
    --end
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
        -- program is in 1, args in 2 -> evaluated in this order, fixed later with adapters.c.enrichConfig
        function()
            return coroutine.create(function(dap_run_co)
                local actions = require "telescope.actions"
                local action_state = require "telescope.actions.state"
                require 'telescope.builtin'.find_files({
                    title = "Path to executable",
                    no_ignore = true,
                    find_command = { "fd", "--hidden", "--exclude", ".git", "--no-ignore", "--type", "x", "--color", "never" },
                    attach_mappings = function(buffer_number)
                        actions.select_default:replace(function()
                            actions.close(buffer_number)
                            coroutine.resume(dap_run_co, action_state.get_selected_entry()[1])
                        end)
                        return true
                    end,
                })
            end)
        end,
        function()
            return vim.split(vim.fn.input('Arguments (split on \' +\'): ', '', 'file'), ' +', { trimempty = true })
        end,
        name = "Launch",
        type = "gdb",
        request = "launch",
        --program = function()
        --    local path = vim.fn.input({
        --        prompt = 'Path to executable: ',
        --        default = vim.fn.getcwd() .. '/',
        --        completion = 'file',
        --    })

        --    return (path and path ~= '') and path or dap.ABORT
        --end,
        --xxx_program_args = function()
        --    local args_str = vim.fn.input({
        --        prompt = 'Arguments: ',
        --    })
        --    return vim.split(args_str, ' +')
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



--        program = function()
--            return coroutine.create(function(dap_run_co)
--                local pickers = require("telescope.pickers")
--                local finders = require("telescope.finders")
--                local conf = require("telescope.config").values
--                local actions = require("telescope.actions")
--                local action_state = require("telescope.actions.state")
--                pickers.new({}, {
--                    prompt_title = "Path to executable",
--                    finder = finders.new_oneshot_job(
--                        { "fd", "--hidden", "--exclude", ".git", "--no-ignore", "--type", "x", "--color", "never" },
--                        {}
--                    ),
--                    sorter = conf.generic_sorter({}),
--                    attach_mappings = function(buffer_number)
--                        actions.select_default:replace(function()
--                            actions.close(buffer_number)
--                            coroutine.resume(dap_run_co, action_state.get_selected_entry()[1])
--                        end)
--                        return true
--                    end,
--                }):find()
--            end)
--        end,
