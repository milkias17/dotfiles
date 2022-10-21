local present, dap = pcall(require, "dap")

if not present then
	vim.notify("DAP isn't installed")
end

require("dapui").setup()
require("dap-python").setup("python3")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local dapui = require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

map("n", "<space>dc", require("dap").continue, opts)
map("n", "<space>da", require("dap").step_over, opts)
map("n", "<space>di", require("dap").step_into, opts)
map("n", "<space>do", require("dap").step_out, opts)
map("n", "<leader>b", require("dap").toggle_breakpoint, opts)
map("n", "<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, opts)
map("n", "<leader>lb", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, opts)
map("n", "<leader>dr", require("dap").repl.open, opts)
map("n", "<leader>dl", require("dap").run_last, opts)
map("n", "<space>dt", require("dapui").toggle, opts)
