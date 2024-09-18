-- Run last: https://github.com/mfussenegger/nvim-dap/issues/1025
local last_config = nil

-- instead of require('dap').run_last()
local function debug_run_last()
    local dap = require("dap")
    if last_config then
        dap.run(last_config)
    else
        dap.continue()
    end
end

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
        return vim.split(vim.fn.expand(new_args), " ")
    end
    return config
end

return {
    -- fancy UI for the debugger
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup(opts)

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            -- i like to close em myself
            --dap.listeners.before.event_terminated["dapui_config"] = function()
            --    dapui.close({})
            --end
            --dap.listeners.before.event_exited["dapui_config"] = function()
            --    dapui.close({})
            --end
        end,
    },

    {
        "mfussenegger/nvim-dap",
        recommended = true,
        desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

        dependencies = {
            "rcarriga/nvim-dap-ui",
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
        },

        -- stylua: ignore
        keys = {
            -- old config
            --{ "<leader>dt", function() require("dapui").toggle() end },
            { "<leader>ds", function() require("dapui").open({ reset = true }) end },
            --{ "<Leader>df", function() require("dap").focus_frame() end },
            { "<leader>dl", debug_run_last, desc = "Run Last" },
            --{ "<F5>", function() require("dap").continue() end },
            --{ "<F10>", function() require("dap").step_over() end },
            --{ "<F11>", function() require("dap").step_into() end },
            --{ "<F12>", function() require("dap").step_out() end },
            --{ "<Leader>b", function() require("dap").toggle_breakpoint() end },
            --{ "<Leader>B", function() require("dap").set_breakpoint() end },
            --{ "<Leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end },
            { "<Leader>dm", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Log point message" },
            --{ "<Leader>dr", function() require("dap").repl.open() end },

            -- config from lazyvim
            { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
            --{ "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
            { "<leader>dl", debug_run_last, desc = "Run Last" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<leader>dj", function() require("dap").down() end, desc = "Down" },
            { "<leader>dk", function() require("dap").up() end, desc = "Up" },
            { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over" }, -- changed from "<leader>dO" to "<leader>dn"
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            --{ "<leader>ds", function() require("dap").session() end, desc = "Session" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            --{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
            { "<Leader>df", function() require("dap").focus_frame() end, desc = "Focus executing line" },
        },

        config = function()
            local dap = require("dap")

            local sign = vim.fn.sign_define

            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
            sign("DapStopped", { text = "→", texthl = "DapStoppedSign", linehl = "DapStopped", numhl = "DapStopped" })

            -- Run last: https://github.com/mfussenegger/nvim-dap/issues/1025
            dap.listeners.after.event_initialized["store_config"] = function(session)
                last_config = session.config
            end

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

            -- c, see https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--quiet", "--interpreter=dap" },
                enrich_config = function(config, on_config)
                    local final_config = vim.deepcopy(config)
                    final_config.program = final_config.program or final_config[1]
                    final_config.args = final_config.args or final_config[2]
                    on_config(final_config)
                end,
            }

            -- maybe ref: https://blog.cryptomilk.org/2024/01/02/neovim-dap-and-gdb-14-1/
            dap.configurations.c = {
                {
                    -- program is in 1, args in 2 -> evaluated in this order, fixed later with adapters.c.enrichConfig
                    function()
                        return coroutine.create(function(dap_run_co)
                            local actions = require("telescope.actions")
                            local action_state = require("telescope.actions.state")
                            require("telescope.builtin").find_files({
                                title = "Path to executable",
                                no_ignore = true,
                                find_command = {
                                    "fd",
                                    "--hidden",
                                    "--exclude",
                                    ".git",
                                    "--no-ignore",
                                    "--type",
                                    "x",
                                    "--color",
                                    "never",
                                },
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
                        -- TODO: until now, only escaping ' ' with '\ ' is supported, everything else will remain
                        -- unchanged when passed to application (eg single or double quotes must be removed)
                        -- (this wont be splitted and the backspace will be removed: '\ ' -> ' ')
                        -- (otherwise sep for split is: ' ')
                        local input = vim.fn.input("Arguments: ", "", "file")
                        local args = {}
                        local x = ""

                        for s in vim.gsplit(input, " ", { trimempty = true }) do
                            if string.sub(s, #s, #s) == "\\" then
                                --print(s)
                                x = x .. string.sub(s, 0, #s - 1) .. " "
                            --print(x)
                            else
                                table.insert(args, x .. s)
                                x = ""
                            end
                        end

                        vim.print("using args: " .. vim.inspect(args))

                        return args
                    end,
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }
            dap.configurations.cpp = dap.configurations.c
            dap.configurations.rust = dap.configurations.c

            -- go
            --require("dap-go").setup()
        end,
    },
}
