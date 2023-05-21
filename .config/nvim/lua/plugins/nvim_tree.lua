local config = {
	hijack_cursor = true,
	sync_root_with_cwd = true,
	view = {
		width = "25%",
		number = true,
		relativenumber = true,
	},
	renderer = {
		indent_markers = {
			enable = true,
		},
	},
	diagnostics = {
		enable = true,
	},
	modified = {
		enable = true,
	},
}

local opts = { noremap = true, silent = true }

return {
	{
		"nvim-tree/nvim-tree.lua",
		keys = {
			{ "<A-s>", "<cmd>NvimTreeToggle<cr>", opts },
		},
    opts = config
	},
}
