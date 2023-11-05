local config = {
	-- show_current_context = true,
	-- show_current_context_start = true,
	-- indent = {
	-- 	highlight = {
	-- 		"RainbowRed",
	-- 		"RainbowYellow",
	-- 		"RainbowBlue",
	-- 		"RainbowOrange",
	-- 		"RainbowGreen",
	-- 		"RainbowViolet",
	-- 		"RainbowCyan",
	-- 	},
	-- },
}

return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = config,
		event = { "BufReadPre", "BufNewFile" },
	},
}
