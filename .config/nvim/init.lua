pcall(require, "impatient")

vim.g.did_load_filetypes = 1

local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

vim.g.mapleader = ","

local modules = {
	"general",
	"keymaps",
	"theme",
	"packer_init",
	"plugins",
	"lsp",
}

for i = 1, #modules do
	pcall(require, modules[i])
end
