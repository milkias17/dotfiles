return {
	{ "fladson/vim-kitty", event = "VeryLazy" },

	-- Lsp
	{
		"williamboman/mason.nvim",
		config = true,
		build = ":MasonUpdate",
		cmd = "Mason",
	},
	"mfussenegger/nvim-jdtls",

	-- Debugging
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "nvim-telescope/telescope-dap.nvim", dependencies = { "mfussenegger/nvim-dap" } },
	"mfussenegger/nvim-dap-python",

	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "nvim-lua/popup.nvim", lazy = true },
	{ "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = { "markdown" } },
	{ "dstein64/vim-startuptime", cmd = "StartupTime" },
	{
		"CRAG666/code_runner.nvim",
		config = true,
		cmd = { "RunCode", "RunFile", "RunProject" },
		keys = {
			"<leader>r",
			"<cmd>RunCode<CR>",
			noremap = true,
			silent = true,
		},
	},
}
