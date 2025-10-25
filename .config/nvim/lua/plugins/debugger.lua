local opts = { noremap = true, silent = true }

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
				config = function()
					require("dapui").setup()

					local dap, dapui = require("dap"), require("dapui")
					dap.listeners.before.attach.dapui_config = function()
						dapui.open()
					end
					dap.listeners.before.launch.dapui_config = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated.dapui_config = function()
						dapui.close()
					end
					dap.listeners.before.event_exited.dapui_config = function()
						dapui.close()
					end

          require("dap-go").setup()
				end,
				keys = {
					{
						"<space>dt",
						function()
							require("dapui").toggle()
						end,
						opts,
					},
				},
			},
			{ "mfussenegger/nvim-dap-python", lazy = true },
			{ "leoluz/nvim-dap-go", lazy = true },
		},
		keys = {
			{
				"<space>dc",
				function()
					require("dap").continue()
				end,
				opts,
			},
			{
				"<space>da",
				function()
					require("dap").step_over()
				end,
				opts,
			},
			{
				"<space>di",
				function()
					require("dap").step_into()
				end,
				opts,
			},
			{
				"<space>do",
				function()
					require("dap").step_out()
				end,
				opts,
			},
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				opts,
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				opts,
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				opts,
			},
		},
		config = function()
			require("dap-python").setup("python3")
		end,
	},
}
