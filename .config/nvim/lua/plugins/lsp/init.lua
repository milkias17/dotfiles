local opts = { noremap = true, silent = true }

local plugins = {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "BufReadPost" },
		dependencies = {
			{
				-- "hrsh7th/cmp-nvim-lsp",
				-- enabled = function()
				-- 	return require("lazy.core.config").plugins["nvim-cmp"] ~= nil
				-- end,
			},
			-- {
			-- 	"jose-elias-alvarez/typescript.nvim",
			-- 	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
			-- },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/SchemaStore.nvim",
			"saghen/blink.cmp",
			-- {
			-- 	"j-hui/fidget.nvim",
			-- 	tag = "v1.0.0",
			-- 	config = true,
			-- },
		},
	},
	{ "folke/neodev.nvim", config = true, ft = "lua" },
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "williamboman/mason.nvim", "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	-- 	config = function()
	-- 		require("typescript-tools").setup({
	-- 			settings = {
	-- 				expose_as_code_action = "all",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"dmmulroy/ts-error-translator.nvim",
	-- 	config = true,
	-- 	ft = { "typescript", "typescriptreact" },
	-- },
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = { "pyright", "tsserver", "html", "cssls" },
			automatic_installation = true,
		},
		build = ":MasonUpdate",
		cmd = "Mason",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		opts = {
			ensure_installed = { "pyright", "tsserver", "lua_ls" },
			automatic_installation = true,
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("lsp.lang_servers")
		end,
	},
	-- {
	-- 	"Exafunction/codeium.vim",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		vim.g.codeium_disable_bindings = 1
	-- 		vim.keymap.set("i", "<C-g>", function()
	-- 			return vim.fn["codeium#Accept"]()
	-- 		end, { expr = true, silent = true })
	-- 		vim.keymap.set("i", "<c-;>", function()
	-- 			return vim.fn["codeium#CycleCompletions"](1)
	-- 		end, { expr = true, silent = true })
	-- 		vim.keymap.set("i", "<c-,>", function()
	-- 			return vim.fn["codeium#CycleCompletions"](-1)
	-- 		end, { expr = true, silent = true })
	-- 		vim.keymap.set("i", "<c-x>", function()
	-- 			return vim.fn["codeium#Clear"]()
	-- 		end, { expr = true, silent = true })
	-- 	end,
	-- },
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	event = "InsertEnter",
	-- 	cmd = "Copilot",
	-- 	config = function()
	-- 		require("copilot").setup({
	-- 			suggestion = {
	-- 				enabled = true,
	-- 				auto_trigger = true,
	-- 				keymap = {
	-- 					accept = "<C-g>",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"supermaven-inc/supermaven-nvim",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require("supermaven-nvim").setup({
	-- 			keymaps = {
	-- 				accept_suggestion = "<C-g>",
	-- 				accept_word = "<c-q>",
	-- 			},
	-- 			ignore_filetypes = {
	-- 				"gitcommit",
	-- 				"neo-tree",
	-- 				"oil",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"olimorris/codecompanion.nvim",
		cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
		keys = {
			{
				"<space>a",
				"<cmd>CodeCompanionChat toggle<CR>",
				opts,
			},
			{
				"<space>ap",
				"<cmd>CodeCompanionActions<CR>",
				opts,
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- The following are optional:
			{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
		},
		config = function()
			require("codecompanion").setup({
				display = {
					chat = {
						show_header_separator = false,
					},
				},
				strategies = {
					chat = {
						adapter = "gemini",
					},
					inline = {
						adapter = "gemini",
					},
				},
				-- adapters = {
				-- 	openai = function()
				-- 		return require("codecompanion.adapters").extend("openai", {
				-- 			env = {
				-- 				api_key = os.getenv("OPENAI_API_KEY"),
				-- 			},
				-- 		})
				-- 	end,
				-- },
			})
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		opts = {},
		keys = {
			{

				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{
		"nvim-flutter/flutter-tools.nvim",
		ft = { "dart" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = true,
	},
}

local luasnip = require("plugins.lsp.luasnip")
local cmp = require("plugins.lsp.cmp")
table.insert(plugins, 1, cmp)
table.insert(plugins, luasnip)

return plugins
