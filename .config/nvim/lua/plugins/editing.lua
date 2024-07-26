local autopairs_config = {
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
	{ "windwp/nvim-autopairs", opts = autopairs_config, event = "InsertEnter" },
	-- {
	-- 	"andymass/vim-matchup",
	-- 	config = function()
	-- 		vim.g.matchup_matchparen_offscreen = { method = "popup" }
	-- 	end,
	-- 	ft = { "svelte", "htmldjango" },
	-- },
	{
		"windwp/nvim-ts-autotag",
		opts = {
			opts = {
				enable = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
		},
	},
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
	{
		"mattn/emmet-vim",
		event = "InsertEnter",
		ft = { "html", "htmldjango", "javascript", "typescript", "svelte", "vue" },
	},
	{
		"echasnovski/mini.jump",
		version = false,
	   config = true
	},
	-- {
	-- 	"folke/flash.nvim",
	-- 	event = "VeryLazy",
	-- 	-- @type Flash.Config
	-- 	opts = {},
	-- 	keys = {
	-- 		{
	-- 			"s",
	-- 			mode = { "n", "x", "o" },
	-- 			function()
	-- 				require("flash").jump()
	-- 			end,
	-- 			desc = "Flash",
	-- 		},
	-- 		{
	-- 			"S",
	-- 			mode = { "n", "x", "o" },
	-- 			function()
	-- 				require("flash").treesitter()
	-- 			end,
	-- 			desc = "Flash Treesitter",
	-- 		},
	-- 		{
	-- 			"r",
	-- 			mode = "o",
	-- 			function()
	-- 				require("flash").remote()
	-- 			end,
	-- 			desc = "Remote Flash",
	-- 		},
	-- 		{
	-- 			"R",
	-- 			mode = { "o", "x" },
	-- 			function()
	-- 				require("flash").treesitter_search()
	-- 			end,
	-- 			desc = "Treesitter Search",
	-- 		},
	-- 		{
	-- 			"<c-s>",
	-- 			mode = { "c" },
	-- 			function()
	-- 				require("flash").toggle()
	-- 			end,
	-- 			desc = "Toggle Flash Search",
	-- 		},
	-- 	},
	-- },
}
