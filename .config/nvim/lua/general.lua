local options = {
	number = true,
	relativenumber = true,
	splitbelow = true,
	splitright = true,
	laststatus = 3,
	clipboard = "unnamedplus",
	cursorline = true,
	hlsearch = false,
	showcmd = false,
	showmode = false,
	autoindent = true,
	smartindent = true,
	tabstop = 4,
	softtabstop = 4,
	shiftwidth = 4,
	expandtab = true,
	smarttab = true,
	ignorecase = true,
	smartcase = true,
	showmatch = true,
	encoding = "utf-8",
	swapfile = false,
	backup = true,
	backupdir = os.getenv("HOME") .. "/.nvim/backupdir",
	writebackup = false,
	undodir = os.getenv("HOME") .. "/.nvim/undodir",
	undofile = true,
	lazyredraw = true,
	ttyfast = true,
	mouse = "n",
	scrolloff = 8,
	termguicolors = true,
	wrap = false,
	shell = "/usr/bin/fish",
	title = true,
	updatetime = 50,
	inccommand = "nosplit",
	path = ".,**",
	whichwrap = "b,s,<,>,[,]",
	confirm = true,
	-- timeoutlen = 300,
	-- foldmethod = "expr",
	-- foldexpr = "nvim_treesitter#foldexpr()"
}

vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --vimgrep --no-heading"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Better Cursorline
vim.cmd([[autocmd InsertLeave,WinEnter * set cursorline ]])
vim.cmd([[autocmd InsertEnter,WinLeave * set nocursorline]])
vim.cmd([[autocmd FileType TelescopePrompt set nocursorline]])

-- Automatically enter insert mode in terminals
vim.cmd([[autocmd TermOpen * startinsert]])

-- 2 Spaces per tab in webdev
vim.cmd([[
    augroup webdev
        autocmd!
        autocmd FileType html,htmldjango,css,javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    augroup END 
    ]])

vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])
-- vim.cmd([[au BufWritePre *.c silent! <cmd>%s/\s\+$//e]])

for k, v in pairs(options) do
	vim.opt[k] = v
end

local function last_place()
	if vim.tbl_contains(vim.api.nvim_list_bufs(), vim.api.nvim_get_current_buf()) then
		if not vim.tbl_contains({ "gitcommit", "help", "packer", "qf" }, vim.bo.ft) then
			vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]])
		end
	end
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = "*",
	callback = last_place,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = os.getenv("HOME") .. "/.config/nvim/*",
	callback = function()
		local modules = {
			"general",
			"keymaps",
			"packer_init",
			"plugins",
			"lsp",
		}
		for _, package in pairs(modules) do
			R(package)
		end
	end,
})
