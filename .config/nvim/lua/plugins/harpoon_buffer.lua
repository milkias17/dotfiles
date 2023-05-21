local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
vim.cmd("highlight! TabLineFill guibg=#1E2030 guifg=white")

require("harpoon").setup({
	global_settings = {
		tabline = true,
		tabline_prefix = "   ",
		tabline_suffix = "   ",
	},
})

local ui = require("harpoon.ui")

map("n", "]b", "<cmd>bnext<CR>", opts)
map("n", "[b", "<cmd>bprev<CR>", opts)
map("n", "<leader>bd", "<cmd>bd<CR>", opts)
map("n", "<space>ha", require("harpoon.mark").add_file, opts)
map("n", "<space>hc", require("harpoon.mark").clear_all, opts)
map("n", "<space>hs", ui.toggle_quick_menu, opts)
map("n", "]h", ui.nav_next, opts)
map("n", "[h", ui.nav_prev, opts)
for i = 1, 5 do
	local mapping = string.format("<M-%i>", i)
	map("n", mapping, function()
		ui.nav_file(i)
	end, opts)
end

