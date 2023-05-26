local config = {
	check_ts = true,
	fast_wrap = {
		map = "<M-e>",
		chars = { "{", "[", "(", '"', "'" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
	},
}

return {
	{ "windwp/nvim-autopairs", opts = config, event = "VeryLazy" },
	{ "windwp/nvim-ts-autotag" },
	{
		"kylechui/nvim-surround",
		version = "*",
		config = true,
		event = "VeryLazy",
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		event = "VeryLazy",
	},
	{ "mattn/emmet-vim", event = "VeryLazy" },
}
