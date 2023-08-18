local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

map("n", "0", "^")
map("n", "^", "0")
map("x", "<space>p", '"_dP')
map({"n", "v"}, "<leader>y", '"+y')
map({"n", "v"}, "<leader>d", '"+d')
map({"n", "v"}, "<leader>p", '"+p')
map({"n", "v"}, "<leader>P", '"+P')


-- File Operations
map("n", "<leader>w", "<cmd>w!<CR>")
-- map("n", "<leader>bd", "<cmd>bd!<CR>", opts)
map("n", "<leader>q", "<cmd>q!<CR>")

-- Move line
map("n", "<M-v>", "<cmd>vsp<CR>")
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
map("n", "<C-Left>", "<cmd>vertical resize -3<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +3<CR>")
map("n", "<C-Up>", "<cmd>resize +3<CR>")
map("n", "<C-Down>", "<cmd>vertical resize -3<CR>")
map("n", "<M-w>", "<C-w>")

-- Quickfix and Locallist Binds
map("n", "<space>qo", "<cmd>copen<CR>")
map("n", "<space>qc", "<cmd>cclose<CR>")
map("n", "<C-n>", "<cmd>cnext<CR>")
map("n", "<C-p>", "<cmd>cprev<CR>")
map("n", "<space>lo", "<cmd>lopen<CR>")
map("n", "<space>lc", "<cmd>lclose<CR>")
map("n", "<space>n", "<cmd>lnext<CR>")
map("n", "<space>p", "<cmd>lprev<CR>")

map("n", "<space>ot", "<cmd>terminal<CR>")


map("n", "]b", "<cmd>bnext<CR>")
map("n", "[b", "<cmd>bprev<CR>")
map("n", "<leader>bd", "<cmd>bd<CR>")
