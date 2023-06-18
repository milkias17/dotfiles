return {
	{ "fladson/vim-kitty" },

	-- Lsp
	{
		"williamboman/mason.nvim",
    opts = {
      ensure_installed = {"pyright", "tsserver", "html", "cssls"},
      automatic_installation = true
    },
		build = ":MasonUpdate",
		cmd = "Mason",
    dependencies = {
      "williamboman/mason-lspconfig.nvim"
    }
	},
	{ "mfussenegger/nvim-jdtls", ft = "java" },

	-- Debugging
	-- { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	-- { "nvim-telescope/telescope-dap.nvim", dependencies = { "mfussenegger/nvim-dap" } },
	-- "mfussenegger/nvim-dap-python",

	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "nvim-lua/popup.nvim", lazy = true },
	{
		"iamcco/markdown-preview.nvim",
		build = ":call mkdp#util#install()",
		ft = { "markdown" },
		cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
	},
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
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
	},
}
