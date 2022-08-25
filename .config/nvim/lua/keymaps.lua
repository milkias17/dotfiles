local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("i", "jj", "<ESC>")
map("n", "0", "^")
map("n", "^", "0")

-- File Operations
map("n", "<leader>w", ":w!<CR>")
-- map("n", "<leader>bd", ":bd!<CR>", opts)
map("n", "<leader>q", ":q!<CR>")

-- Move line
map("n", "<M-v>", ":vsp<CR>")
map("n", "<M-j>", ":m +1<CR>==")
map("n", "<M-k>", ":m -2<CR>==")
map("i", "<M-j>", "<Esc>:m +1<CR>==gi")
map("i", "<M-k>", "<Esc>:m -2<CR>==gi")
map("v", "<M-j>", ":m '>+1<CR>gv=gv")
map("v", "<M-k>", ":m '<-2<CR>gv=gv")

-- Insert new line and stay in normal mode
map("n", "[<Space>", "O<ESC>")
map("n", "]<Space>", "o<ESC>")

-- Reselect visual selection after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Go to end and beginning of line in insert mode
map("i", "<C-e>", "<C-o>$")
map("i", "<C-a>", "<C-o>^")

-- Create new line in insert mode
map("i", "<M-m>", "<C-o>o")

-- Splits and Resizing splits
-- map("n", "<C-h>", "<C-w>h")
-- map("n", "<C-j>", "<C-w>j")
-- map("n", "<C-k>", "<C-w>k")
-- map("n", "<C-l>", "<C-w>l")
map("n", "<C-Left>", ":vertical resize -3<CR>")
map("n", "<C-Right>", ":vertical resize +3<CR>")
map("n", "<C-Up>", ":resize +3<CR>")
map("n", "<C-Down>", ":vertical resize -3<CR>")
map("n", "<M-w>", "<C-w>")

-- Quickfix and Locallist Binds
map("n", "<space>qo", ":copen<CR>")
map("n", "<space>qc", ":cclose<CR>")
map("n", "<C-n>", ":cnext<CR>")
map("n", "<C-p>", ":cprev<CR>")
map("n", "<space>lo", ":lopen<CR>")
map("n", "<space>lc", ":lclose<CR>")
map("n", "<space>n", ":lnext<CR>")
map("n", "<space>p", ":lprev<CR>")

map("n", "<space>ot", "<cmd>terminal<CR>")
