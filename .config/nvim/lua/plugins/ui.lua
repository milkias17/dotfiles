-- require("github-theme").setup()
--
-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
-- require("catppuccin").setup()
-- vim.cmd.colorscheme("catppuccin")

-- require("onedark").load()

-- vim.cmd.colorscheme("base16-onedark")
-- vim.opt.fillchars = "eob: "

-- vim.g.material_style = "deep ocean"
-- require("material").setup({
-- 	contrast = {
-- 		sidebars = true,
-- 		floating_windows = true,
-- 	},
-- 	disable = {
-- 		eob_lines = true,
-- 	},
-- })
-- vim.cmd([[ colorscheme material ]])

-- vim.cmd.colorscheme("onedark")
-- vim.cmd.colorscheme("my_theme")

-- require("onedark").setup({
-- 	customTelescope = true,
-- })

-- return {
-- 	{
-- 		"navarasu/onedark.nvim",
-- 		priority = 1000,
-- 		config = function()
-- 			require("onedark").load()
-- 		end,
-- 		lazy = true,
-- 	},
-- 	{
-- 		"catppuccin/nvim",
-- 		name = "catppuccin",
-- 		priority = 1000,
-- 		config = function()
-- 			-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
-- 			-- require("catppuccin").setup()
-- 			vim.cmd.colorscheme("catppuccin")
-- 		end,
-- 	},
-- 	{ "marko-cerovac/material.nvim", priority = 1000, lazy = true },
-- 	{ "nyoom-engineering/oxocarbon.nvim", priority = 1000, lazy = true },
-- 	{ "RRethy/nvim-base16", priority = 1000 },
-- 	{ "folke/tokyonight.nvim", priority = 1000, lazy = true },
-- }
--
return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				tailwind = true, -- Enable tailwind colors
			},
		},
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
			vim.keymap.set("n", "<space>nd", function()
				require("notify").dismiss()
			end, { silent = true, noremap = true })
		end,
		event = "VeryLazy",
	},

	-- themes
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				custom_highlights = function(colors)
					return {
						MiniJump = { bg = colors.red },
					}
				end,
				integrations = {
					neogit = true,
					gitsigns = true,
					neotree = true,
					mason = true,
					telescope = {
						enabled = true,
					},
					notify = true,
					cmp = true,
					native_lsp = {
						enabled = true,
					},
					treesitter = true,
					treesitter_context = true,
					indent_blankline = {
						enabled = false,
						colored_indent_levels = true,
					},
					harpoon = true,
					semantic_tokens = true,
					lsp_trouble = true,
					mini = {
						enabled = true,
					},
					flash = false,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{ "RRethy/nvim-base16", priority = 1000, event = "VeryLazy" },
	{ "marko-cerovac/material.nvim", priority = 1000, lazy = true },
	{ "EdenEast/nightfox.nvim", priority = 1000, lazy = true },
	{
		"nyoom-engineering/oxocarbon.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("oxocarbon")
		end,
		lazy = true,
	},
	{ "navarasu/onedark.nvim", priority = 1000, lazy = true },
	{ "folke/tokyonight.nvim", priority = 1000, lazy = true },
	-- lazy.nvim
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		lsp = {
	-- 			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
	-- 			override = {
	-- 				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	-- 				["vim.lsp.util.stylize_markdown"] = true,
	-- 				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
	-- 			},
	-- 		},
	-- 		-- you can enable a preset for easier configuration
	-- 		presets = {
	-- 			bottom_search = true, -- use a classic bottom cmdline for search
	-- 			command_palette = true, -- position the cmdline and popupmenu together
	-- 			long_message_to_split = true, -- long messages will be sent to a split
	-- 			inc_rename = false, -- enables an input dialog for inc-rename.nvim
	-- 			lsp_doc_border = false, -- add a border to hover docs and signature help
	-- 		},
	-- 	},
	-- 	dependencies = {
	-- 		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	-- 		"MunifTanjim/nui.nvim",
	-- 		-- OPTIONAL:
	-- 		--   `nvim-notify` is only needed, if you want to use the notification view.
	-- 		--   If not available, we use `mini` as the fallback
	-- 		"rcarriga/nvim-notify",
	-- 	},
	-- },
}
