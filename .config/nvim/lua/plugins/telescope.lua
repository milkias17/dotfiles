local config = {
	defaults = {
		file_ignore_patterns = { "node_modules/", "__pycache__/", "env/" },
		mappings = {
			i = {
				["<C-h>"] = "which_key",
				["<esc>"] = "close",
        ["<C-t>"] = function(prompt_bufnr)
          local entry = require("telescope.actions.state").get_selected_entry()
          require("harpoon.mark").add_file(entry[1])
          require("telescope.actions").close(prompt_bufnr)
        end,
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
		},
    cmd = "Telescope",
		keys = {
			{ "<space>f", function() require("telescope.builtin").find_files() end, opts },
			{ "<space>gf", function() require("telescope.builtin").git_files() end, opts },
			{ "<space>l", function() require("telescope.builtin").live_grep() end, opts },
			{ "<space>b", function() require("telescope.builtin").buffers() end, opts },
			{
				"<space>tt",
				function()
					require("telescope.builtin").colorscheme({ enable_preview = true })
				end,
				opts,
			},
			{ "<space>tc", function() require("telescope.builtin").commands() end, opts },
			{ "<space>th", function() require("telescope.builtin").help_tags() end, opts },
			{ "<space>ts", function() require("telescope.builtin").grep_string() end, opts },
			{ "<space>ds", function() require("telescope.builtin").lsp_document_symbols() end, opts },
			{ "<space>tk", function() require("telescope.builtin").keymaps() end, opts },
			{ "<space>tm", "<cmd>Telescope media_files<cr>", opts },
			{ "<space>nc", search_dotfiles, opts },
			{ "<space>cw", change_wallpaper, opts },
		},
		config = function()
      require("telescope").setup(config)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("media_files")
      require("telescope").load_extension("notify")
		end,
	},
}
