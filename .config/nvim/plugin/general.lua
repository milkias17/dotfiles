local options = {
	number = true,
	relativenumber = true,
	splitbelow = true,
	splitright = true,
	laststatus = 3,
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
	scrolloff = 999,
	termguicolors = true,
	wrap = true,
	shell = "/usr/bin/fish",
	title = true,
	updatetime = 50,
	path = ".,**",
	whichwrap = "b,s,<,>,[,]",
	confirm = true,
	timeout = true,
	timeoutlen = 300,
	list = true, -- show tabs and other messy stuff in buffer
	breakindent = true,
	showtabline = 2,
	inccommand = "split",
	-- foldmethod = "expr",
	-- foldexpr = "nvim_treesitter#foldexpr()"
}

-- This is needed by completion plugins
vim.opt.shortmess:append("c")
vim.o.completeopt = "menuone,noselect"

-- Treat - separated words as a single word
vim.opt.iskeyword:append("-")
-- vim.opt.listchars:append("eol:↴")

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --vimgrep --no-heading"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Better Cursorline
vim.cmd([[autocmd InsertLeave,WinEnter * set cursorline ]])
vim.cmd([[autocmd InsertEnter,WinLeave * set nocursorline]])
vim.cmd([[autocmd FileType TelescopePrompt set nocursorline]])

-- 2 Spaces per tab in webdev
vim.cmd([[
    augroup webdev
        autocmd!
        autocmd FileType html,htmldjango,css,javascript,javascriptreact,typescript,typescriptreact,svelte setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    augroup END
    ]])

local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
	callback = function()
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
		if ok and stats and (stats.size > 1000000) then
			vim.b.large_buf = true
			vim.cmd("syntax off")
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
		else
			vim.b.large_buf = false
		end
	end,
	group = aug,
	pattern = "*",
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

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

vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})
