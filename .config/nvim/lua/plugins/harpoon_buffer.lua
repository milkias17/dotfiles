local opts = { noremap = true, silent = true }

local config = {
	global_settings = {
		tabline = true,
		tabline_prefix = "   ",
		tabline_suffix = "   ",
	},
}

return {
	{
		"ThePrimeagen/harpoon",
		lazy = true,
		keys = {
			{ "<space>ha", function() require("harpoon.mark").add_file() end, opts },
			{ "<space>hc", function() require("harpoon.mark").clear_all() end, opts },
			{ "<space>hs", function() require("harpoon.ui").toggle_quick_menu() end, opts },
			{ "]h", function() require("harpoon.ui").nav_next() end, opts },
			{ "[h", function() require("harpoon.ui").nav_prev() end, opts },
      { "<M-1>", function() require("harpoon.ui").nav_file(1) end, opts },
      { "<M-2>", function() require("harpoon.ui").nav_file(2) end, opts },
      { "<M-3>", function() require("harpoon.ui").nav_file(3) end, opts },
      { "<M-4>", function() require("harpoon.ui").nav_file(4) end, opts },
      { "<M-5>", function() require("harpoon.ui").nav_file(5) end, opts },
		},
		opts = config,
		config = function()
			vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
			vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
			vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! TabLineFill guibg=#1E2030 guifg=white")
		end,
	},
}
