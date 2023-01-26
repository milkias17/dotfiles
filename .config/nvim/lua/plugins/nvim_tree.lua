local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
	return
end

nvim_tree.setup({
    hijack_cursor = true,
    sync_root_with_cwd = true,
    view = {
        width = "25%",
        number = true,
        relativenumber = true
    },
    renderer = {
        indent_markers = {
            enable = true
        },
    },
    diagnostics = {
        enable = true
    },
    modified = {
        enable = true
    }
})


local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

map("n", "<A-s>", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>r", ":NvimTreeRefresh<CR>", opts)
map("n", "<leader>n", ":NvimTreeFindFile<CR>", opts)
