local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
	{ "williamboman/mason.nvim", config = true, build = ":MasonUpdate" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	"windwp/nvim-autopairs",
	{ "windwp/nvim-ts-autotag", ft = { "html", "javascript", "htmldjango" } },
	"p00f/nvim-ts-rainbow",
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = true,
	},
	"fladson/vim-kitty",
	"lukas-reineke/indent-blankline.nvim",
	{ "Wansmer/treesj", config = true },

	-- Lsp
	"neovim/nvim-lspconfig",
	"jose-elias-alvarez/null-ls.nvim",
	"jose-elias-alvarez/typescript.nvim",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"mfussenegger/nvim-jdtls",
	"napmn/react-extract.nvim",

	-- Debugging
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "nvim-telescope/telescope-dap.nvim", dependencies = { "mfussenegger/nvim-dap" } },
	"mfussenegger/nvim-dap-python",
	{ "L3MON4D3/LuaSnip" },
	"rafamadriz/friendly-snippets",
	{
		"dsznajder/vscode-es7-javascript-react-snippets",
		build = "yarn install --frozen-lockfile && yarn compile",
	},
	"mattn/emmet-vim",

	{ "projekt0n/github-nvim-theme", priority = 100 },
	{
		"catppuccin/nvim",
		as = "catppuccin",
		priority = 100,
	},
	{ "marko-cerovac/material.nvim", priority = 100 },
	{ "nyoom-engineering/oxocarbon.nvim", priority = 100 },
	{ "projekt0n/github-nvim-theme", priority = 100 },
	{ "navarasu/onedark.nvim", priority = 100 },
	{ "RRethy/nvim-base16", priority = 100 },

	"NvChad/nvim-colorizer.lua",
	"nvim-lualine/lualine.nvim",
	"romgrk/barbar.nvim",
	"kyazdani42/nvim-web-devicons",
	"kyazdani42/nvim-tree.lua",

	-- Git
	"sindrets/diffview.nvim",
	"tpope/vim-fugitive",
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
	},
	"numToStr/Comment.nvim",

	{ "nvim-lua/plenary.nvim" },
	{ "nvim-lua/popup.nvim" },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope-media-files.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-lua/popup.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			},
			{
				"nvim-telescope/telescope-media-files.nvim",
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
			vim.keymap.set("n", "<space>nd", function()
				require("notify").dismiss()
			end, { silent = true, noremap = true })
		end,
	},
	{ "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = { "markdown" } },
	"dstein64/vim-startuptime",
	"lewis6991/impatient.nvim",
    {"CRAG666/code_runner.nvim", config = true },

	"milkias17/reloader.nvim",
})
