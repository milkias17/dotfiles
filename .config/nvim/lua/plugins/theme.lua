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

}
