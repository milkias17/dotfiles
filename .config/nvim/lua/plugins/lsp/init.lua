local plugins = {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"hrsh7th/cmp-nvim-lsp",
				-- enabled = function()
				-- 	return require("lazy.core.config").plugins["nvim-cmp"] ~= nil
				-- end,
			},
			{ "folke/neodev.nvim", config = true },
			-- {
			-- 	"jose-elias-alvarez/typescript.nvim",
			-- 	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
			-- },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/SchemaStore.nvim",
			{
				"j-hui/fidget.nvim",
				tag = "v1.0.0",
				config = true,
			},
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "williamboman/mason.nvim" },
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			require("typescript-tools").setup({})
			local actions = {
				["Organize Imports"] = "TSToolsOrganizeImports",
				["Sort Imports"] = "TSToolsSortImports",
				["Remove Unused Imports"] = "TSToolsRemoveUnused",
				["Go to Source Definition"] = "TSToolsGoToSourceDefinition",
				["Add Missing Imports"] = "TSToolsAddMissingImports",
				["Fix All"] = "TSToolsFixAll",
			}
			local function code_action()
				vim.ui.select(vim.tbl_keys(actions), {
					prompt = "Select Action",
				}, function(selection)
					vim.cmd(actions[selection])
				end)
			end

			vim.keymap.set("n", "<leader>ca", code_action, { silent = true, noremap = true })
		end,
	},
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
		event = { "BufReadPre", "BufNewFile" },
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
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cmd = "Copilot",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<C-g>",
					},
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>" },
			{ "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
			{ "<leader>tt", "<cmd>TroubleToggle<cr>" },
		},
	},
}

local luasnip = require("plugins.lsp.luasnip")
local cmp = require("plugins.lsp.cmp")
table.insert(plugins, 1, cmp)
table.insert(plugins, luasnip)

return plugins
