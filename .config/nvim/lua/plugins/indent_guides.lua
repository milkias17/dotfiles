local config = {
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
		-- opts = config,
		opts = {},
		event = { "BufReadPre", "BufNewFile" },
	},
	-- {
	-- 	"echasnovski/mini.indentscope",
	-- 	version = "*",
	-- 	event = { "BufReadPre", "BufNewFile" },
	--    config = true
	-- },
}
