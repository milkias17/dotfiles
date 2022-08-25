local status, neogit = pcall(require, "neogit")
if not status then
	return
end

neogit.setup({
	kind = "split_above",
	disable_commit_confirmation = true,
	integrations = {
		diffview = true,
	},
})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<space>ng", neogit.open, opts)
