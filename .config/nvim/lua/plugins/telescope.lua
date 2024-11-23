local config = {
	defaults = {
		file_ignore_patterns = { "node_modules/", "__pycache__/", "env/" },
		history = {
			path = vim.fs.joinpath(vim.fn.stdpath("data"), "telescope_history.sqlite3"),
			limit = 100,
		},
		mappings = {
			i = {
				["<C-Down>"] = require("telescope.actions").cycle_history_next,
				["<C-Up>"] = require("telescope.actions").cycle_history_prev,
				["<C-h>"] = "which_key",
				["<esc>"] = "close",
				["<C-t>"] = function(prompt_bufnr)
					local entry = require("telescope.actions.state").get_selected_entry()
					require("harpoon.mark").add_file(entry[1])
					require("telescope.actions").select_default(prompt_bufnr)
					vim.schedule_wrap(function()
						require("telescope.actions").close(prompt_bufnr)
					end)
				end,
			},
		},
	},
	["ui-select"] = {
		require("telescope.themes").get_dropdown({}),
	},
	pickers = {
		find_files = {
			theme = "ivy",
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
}

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

local opts = { noremap = true, silent = true }

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{
				"nvim-telescope/telescope-media-files.nvim",
			},
			{ "nvim-telescope/telescope-smart-history.nvim", dependencies = { "kkharji/sqlite.lua" } },
			"telescope-ui-select.nvim",
		},
		cmd = "Telescope",
		keys = {
			{
				"<space>f",
				function()
					require("telescope.builtin").find_files()
				end,
				opts,
			},
			{
				"<space>gf",
				function()
					require("telescope.builtin").git_files()
				end,
				opts,
			},
			{
				"<space>l",
				function()
					require("telescope.builtin").live_grep(require("telescope.themes").get_ivy({}))
				end,
				opts,
			},
			{
				"<space>b",
				function()
					require("telescope.builtin").buffers(require("telescope.themes").get_ivy({}))
				end,
				opts,
			},
			{
				"<space>tt",
				function()
					require("telescope.builtin").colorscheme({ enable_preview = true })
				end,
				opts,
			},
			{
				"<space>tc",
				function()
					require("telescope.builtin").commands(require("telescope.themes").get_ivy({}))
				end,
				opts,
			},
			{
				"<space>th",
				function()
					require("telescope.builtin").help_tags(require("telescope.themes").get_ivy({}))
				end,
				opts,
			},
			{
				"<space>ts",
				function()
					require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({}))
				end,
				opts,
			},
			{
				"<space>ds",
				function()
					require("telescope.builtin").lsp_document_symbols(require("telescope.themes").get_ivy({}))
				end,
				opts,
			},
			{
				"<space>tk",
				function()
					require("telescope.builtin").keymaps(require("telescope.themes").get_ivy({}))
				end,
				opts,
			},
			{ "<space>tm", "<cmd>Telescope media_files<cr>", opts },
			{ "<space>nc", search_dotfiles, opts },
			{ "<space>cw", change_wallpaper, opts },
		},
		config = function()
			require("telescope").setup(config)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("smart_history")
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("media_files")
			require("telescope").load_extension("notify")
		end,
	},
}
