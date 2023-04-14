vim.keymap.set({ "v" }, "<leader>re", require("react-extract").extract_to_new_file)
vim.keymap.set({ "v" }, "<leader>rc", require("react-extract").extract_to_current_file)
