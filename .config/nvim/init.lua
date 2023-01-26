pcall(require, "impatient")

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
	"packer_init",
    "theme",
	"plugins",
	"lsp",
	-- "debugger",
}
for _, mdl in ipairs(modules) do
	pcall(require, mdl)
end
