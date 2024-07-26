-- require("github-theme").setup()
--
-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
require("catppuccin").setup({
	flavour = "macchiato",
	integrations = {
		neogit = true,
		gitsigns = true,
		neotree = true,
		telescope = true,
		notify = true,
		cmp = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
			inlay_hints = {
				background = true,
			},
		},
		treesitter = true,
		treesitter_context = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = false,
		},
		harpoon = true,
		semantic_tokens = true,
		lsp_trouble = true,
		mason = true,
    flash = true
	},
})
vim.cmd.colorscheme("catppuccin")

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
