local status, telescope = pcall(require, "telescope")
if not status then
	return
end

telescope.setup({
	defaults = {
		file_ignore_patterns = { "node_modules/", "__pycache__/", "env/" },
		mappings = {
			i = {
				["<C-h>"] = "which_key",
				["<esc>"] = "close",
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("media_files")

local function search_dotfiles()
	require("telescope.builtin").find_files({
		search_dirs = { "~/.config/nvim/", "~/.config/kitty/", "~/.config/qtile/", "~/.config/fish/" },
	})
end

local function change_wallpaper()
	require("telescope.builtin").find_files({
		prompt_title = "Set Wallpaper",
		cwd = "~/Pictures/Walls/",
		attach_mappings = function(prompt_bufnr, map)
			local function set_wallpaper(close)
				local wallpaper = require("telescope.actions.state").get_selected_entry()
				vim.fn.system("feh --bg-scale " .. wallpaper.cwd .. "/" .. wallpaper.value)
				if close then
					require("telescope.actions").close(prompt_bufnr)
				end
			end
			map("i", "<C-p>", function()
				set_wallpaper()
			end)
			map("i", "<CR>", function()
				set_wallpaper(true)
			end)

			return true
		end,
	})
end

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local builtin = require("telescope.builtin")

map("n", "<space>f", builtin.find_files, opts)
map("n", "<space>gf", builtin.git_files, opts)
map("n", "<space>l", builtin.live_grep, opts)
map("n", "<space>b", builtin.buffers, opts)
map("n", "<space>tt", function ()
    builtin.colorscheme({
        enable_preview = true
    })
end, opts)
map("n", "<space>tc", builtin.commands, opts)
map("n", "<space>th", builtin.help_tags, opts)
map("n", "<space>ts", builtin.grep_string, opts)
map("n", "<space>ds", builtin.lsp_document_symbols, opts)
map("n", "<space>tk", builtin.keymaps, opts)
map("n", "<space>tm", telescope.extensions.media_files.media_files, opts)
map("n", "<space>nc", search_dotfiles, opts)
map("n", "<space>cw", change_wallpaper, opts)
