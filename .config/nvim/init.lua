if vim.loader then
	vim.loader.enable()
end

vim.g.mapleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"zip",
				"zipPlugin",
				"tar",
				"tarPlugin",

				"netrwPlugin",
				"netrw",
				"netrwSettings",

				"tohtml",
				"2html_plugin",
				"getscript",
				"vimball",
				"vimballPlugin",
			},
		},
	},
	dev = {
		path = "~/Dev/plugins/",
	},
	install = {
		colorscheme = { "catppuccin", "habamaz" },
	},
	checker = {
		enabled = false,
	},
	change_detection = {
		enabled = false,
		notify = false,
	},
	profiling = {
		-- Enables extra stats on the debug tab related to the loader cache.
		-- Additionally gathers stats about all package.loaders
		loader = true,
		-- Track each new require in the Lazy profiling tab
		require = true,
	},
})
