local present, dap = pcall(require, "dap")

if not present then
	vim.notify("DAP isn't installed")
end

require("dapui").setup()
require("dap-python").setup("debugpy")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<F5>", require("dap").continue, opts)
map("n", "<F10>", require("dap").step_over, opts)
map("n", "<F11>", require("dap").step_into, opts)
map("n", "<F12>", require("dap").step_out, opts)
map("n", "<leader>b", require("dap").toggle_breakpoint, opts)
map("n", "<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, opts)
map("n", "<leader>lb", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, opts)
map("n", "<leader>dr", require("dap").repl.open, opts)
map("n", "<leader>dl", require("dap").run_last, opts)
map("n", "<space>do", require("dapui").toggle, opts)
