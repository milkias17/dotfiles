local plugins = {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "folke/neodev.nvim", config = true },
			{
				"hrsh7th/cmp-nvim-lsp",
			},
			{
				"jose-elias-alvarez/typescript.nvim",
				ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
			},
			"williamboman/mason.nvim",
		},
		config = function()
			require("lsp.lang_servers")
		end,
	},
	{
		"Exafunction/codeium.vim",
		event = "InsertEnter",
		config = function()
			vim.g.codeium_disable_bindings = 1
			vim.keymap.set("i", "<C-g>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-;>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-,>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true })
		end,
	},
}

local luasnip = require("plugins.lsp.luasnip")
local cmp = require("plugins.lsp.cmp")
local null_ls = require("plugins.lsp.null_ls")
table.insert(plugins, luasnip)
table.insert(plugins, cmp)
table.insert(plugins, null_ls)

return plugins
