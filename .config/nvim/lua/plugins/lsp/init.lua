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
	-- {
	-- 	"luckasRanarison/tailwind-tools.nvim",
	-- 	name = "tailwind-tools",
	-- 	build = ":UpdateRemotePlugins",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"nvim-telescope/telescope.nvim", -- optional
	-- 		"neovim/nvim-lspconfig", -- optional
	-- 	},
	-- 	opts = {}, -- your configuration
	-- },
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
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-g>",
					accept_word = "<c-q>",
				},
				ignore_filetypes = {
					"gitcommit",
					"neo-tree",
					"oil",
				},
			})
		end,
	},
	-- {
	-- 	"Exafunction/windsurf.nvim",
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	config = function()
	-- 		local opts = {
	--        enable_cmp_source = false,
	-- 			virtual_text = {
	-- 				enabled = true,
	-- 				key_bindings = {
	-- 					accept = "<A-a>",
	-- 					accept_word = "<A-w>",
	-- 					accept_line = "<A-l>",
	-- 					clear = "<A-c>",
	-- 					next = "<A-n>",
	-- 					prev = "<A-p>",
	-- 				},
	-- 			},
	-- 		}
	--
	-- 		require("codeium").setup(opts)
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
			{
				"<leader>gc",
				"<cmd>CodeCompanionGitCommit<CR>",
				opts,
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"jinzhongjia/codecompanion-gitcommit.nvim",
				ft = "gitcommit",
				cmd = "CodeCompanionGitCommit",
				opts = {
					adapter = "groq",
					model = "meta-llama/llama-4-scout-17b-16e-instruct",
				},
				-- keys = {
				-- 	{ "<leader>cm", "<cmd>CodeCompanionGitCommit<CR>", opts },
				-- },
			},
			-- -- The following are optional:
			{ "MeanderingProgrammer/render-markdown.nvim", ft = { "codecompanion" } },
		},
		config = function()
			require("codecompanion").setup({
				opts = {
					log_level = "DEBUG",
				},
				adapters = {
					http = {
						groq = function()
							return require("codecompanion.adapters").extend("openai", {
								env = {
									api_key = vim.env.GROQ_API_KEY,
								},
								name = "Groq",
								url = "https://api.groq.com/openai/v1/chat/completions",
								schema = {
									model = {
										-- default = "gemma2-9b-it",
										-- default = "meta-llama/llama-4-scout-17b-16e-instruct",
										-- default = "deepseek-r1-distill-llama-70b",
										default = "moonshotai/kimi-k2-instruct-0905",
										-- default = "openai/gpt-oss-120b",
									},
								},
								max_tokens = {
									default = 8192,
								},
								temperature = {
									default = 1,
								},
							})
						end,
					},
					acp = {
						gemini_cli = function()
							return require("codecompanion.adapters").extend("gemini_cli", {
								defaults = {
									auth_method = "gemini-api-key", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
								},
								env = {
									GEMINI_API_KEY = vim.env.GEMINI_API_KEY,
								},
							})
						end,
					},
				},
				display = {
					chat = {
						show_header_separator = true,
					},
					action_palette = {
						opts = {
							show_default_actions = true,
						},
					},
				},
				strategies = {
					chat = {
						adapter = "groq",
					},
					inline = {
						adapter = "gemini",
					},
				},
				extensions = {
					gitcommit = {
						callback = "codecompanion._extensions.gitcommit",
						opts = {
							-- File filtering (optional)
							exclude_files = {
								"*.pb.go",
								"*.min.js",
								"*.min.css",
								"package-lock.json",
								"yarn.lock",
								"*.log",
								"dist/*",
								"build/*",
								".next/*",
								"node_modules/*",
								"vendor/*",
							},

							-- Buffer integration
							buffer = {
								enabled = false, -- Enable gitcommit buffer keymaps
								keymap = "<leader>gc", -- Keymap for generating commit messages
								auto_generate = false, -- Auto-generate on buffer enter
								auto_generate_delay = 200, -- Auto-generation delay (ms)
							},

							-- Feature toggles
							add_slash_command = true, -- Add /gitcommit slash command
							add_git_tool = true, -- Add @git_read and @git_edit tools
							enable_git_read = true, -- Enable read-only Git operations
							enable_git_edit = true, -- Enable write-access Git operations
							enable_git_bot = true, -- Enable @git_bot tool group (requires both read/write enabled)
							add_git_commands = true, -- Add :CodeCompanionGitCommit commands
						},
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
