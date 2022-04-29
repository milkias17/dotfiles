vim.cmd([[ packadd packer.nvim ]])
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
	git = {
		clone_timeout = 120, -- Timeout, in seconds, for git clones
	},
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	--Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("nvim-treesitter/playground")
	use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" })
	use("windwp/nvim-autopairs")
	use({ "windwp/nvim-ts-autotag", opt = true, ft = { "html", "javascript", "htmldjango" } })
	use({ "p00f/nvim-ts-rainbow", after = "nvim-treesitter" })

	-- Lsp
	use("neovim/nvim-lspconfig")
	use({ "jose-elias-alvarez/null-ls.nvim", after = "nvim-lspconfig" })
	use({
		"hrsh7th/nvim-cmp",
		after = "friendly-snippets",
	})
	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
	use({ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" })
	use({
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		after = { "nvim-lspconfig" },
	})

	-- Snippets
	use({
		"L3MON4D3/LuaSnip",
		wants = "friendly-snippets",
		after = "nvim-cmp",
	})
	use("rafamadriz/friendly-snippets")
	use({
		"dsznajder/vscode-es7-javascript-react-snippets",
		run = "yarn install --frozen-lockfile && yarn compile",
	})
	use({ "mattn/emmet-vim", ft = { "html", "javascript", "javascriptreact", "htmldjango" } })

	-- Visual Stuff
	use("ful1e5/onedark.nvim")
	use("projekt0n/github-nvim-theme")
	-- use("joshdick/onedark.vim")
	use("norcalli/nvim-colorizer.lua")
	use("nvim-lualine/lualine.nvim")
	use("romgrk/barbar.nvim")
	-- use("akinsho/bufferline.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	use({
		"j-hui/fidget.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("fidget").setup({})
		end,
	})
	-- use("lukas-reineke/indent-blankline.nvim")

	-- Utils
	use("TimUntersberger/neogit")
	use("sindrets/diffview.nvim")
	use("tpope/vim-surround")
	use({ "tpope/vim-commentary", event = "VimEnter" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
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
	})
	use({ "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()", ft = { "markdown" } })
	-- use({ "tweekmonster/startuptime.vim", opt = true, cmd = { "StartupTime" } })
	use({ "dstein64/vim-startuptime", cmd = { "StartupTime" } })
	use("lewis6991/impatient.nvim")
	use("nathom/filetype.nvim")

	-- Install plugins on first load
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
