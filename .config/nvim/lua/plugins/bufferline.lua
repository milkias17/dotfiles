vim.g.bufferline = {
	animation = false,
	auto_hide = false,
	tabpages = true,
	closable = true,
	clickable = true,
	icons = true,
	icon_custom_colors = false,
	icon_separator_active = "▎",
	icon_separator_inactive = "▎",
	icon_close_tab = "",
	icon_close_tab_modified = "●",
	icon_pinned = "車",
	insert_at_end = false,
	insert_at_start = false,
	maximum_padding = 1,
	maximum_length = 30,
	semantic_letters = true,
	letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
	no_name_title = "[No Name]",
}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map("n", "<S-tab>", "<cmd>BufferPrevious<CR>", opts)
map("n", "<tab>", "<cmd>BufferNext<CR>", opts)
map("n", "<leader>mp", "<cmd>BufferMovePrevious<CR>", opts)
map("n", "<leader>mn", " <cmd>BufferMoveNext<CR>", opts)
map("n", "<leader>bd", "<cmd>BufferClose<CR>", opts)