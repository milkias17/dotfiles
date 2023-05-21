return {
	{ "williamboman/mason.nvim", config = true, build = ":MasonUpdate" },
	"fladson/vim-kitty",

	-- Lsp
	"neovim/nvim-lspconfig",
	"jose-elias-alvarez/null-ls.nvim",
	"jose-elias-alvarez/typescript.nvim",

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
	},
	"mfussenegger/nvim-jdtls",

	-- Debugging
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "nvim-telescope/telescope-dap.nvim", dependencies = { "mfussenegger/nvim-dap" } },
	"mfussenegger/nvim-dap-python",
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			{
				"dsznajder/vscode-es7-javascript-react-snippets",
				build = "yarn install --frozen-lockfile && yarn compile",
			},
			"rafamadriz/friendly-snippets",
		},
	},
	"mattn/emmet-vim",

	{ "nvim-lua/plenary.nvim" },
	{ "nvim-lua/popup.nvim" },
	{ "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = { "markdown" } },
	{ "dstein64/vim-startuptime", cmd = "StartupTime" },
	{ "CRAG666/code_runner.nvim", config = true },

	{ "folke/neodev.nvim" },
}
