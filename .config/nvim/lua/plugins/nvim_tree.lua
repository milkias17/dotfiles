local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
	return
end

-- nvim_tree.setup({
-- 	git_ignore = 1,
-- 	-- disables netrw completely
-- 	disable_netrw = true,
-- 	-- hijack netrw window on startup
-- 	hijack_netrw = true,
-- 	-- open the tree when running this setup function
-- 	open_on_setup = false,
-- 	-- will not open on setup if the filetype is in this list
-- 	ignore_ft_on_setup = {},
-- 	-- closes neovim automatically when the tree is the last **WINDOW** in the view
-- 	auto_close = false,
-- 	-- opens the tree when changing/opening a new tab if the tree wasn't previously opened
-- 	open_on_tab = false,
-- 	-- hijacks new directory buffers when they are opened.
-- 	update_to_buf_dir = {
-- 		-- enable the feature
-- 		enable = true,
-- 		-- allow to open the tree if it was previously closed
-- 		auto_open = true,
-- 	},
-- 	-- hijack the cursor in the tree to put it at the start of the filename
-- 	hijack_cursor = false,
-- 	-- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
-- 	update_cwd = false,
-- 	-- show lsp diagnostics in the signcolumn
-- 	diagnostics = {
-- 		enable = false,
-- 		icons = { hint = "", info = "", warning = "", error = "" },
-- 	},
-- 	-- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
-- 	update_focused_file = {
-- 		-- enables the feature
-- 		enable = false,
-- 		-- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
-- 		-- only relevant when `update_focused_file.enable` is true
-- 		update_cwd = false,
-- 		-- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
-- 		-- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
-- 		ignore_list = {},
-- 	},
-- 	-- configuration options for the system open command (`s` in the tree by default)
-- 	system_open = {
-- 		-- the command to run this, leaving nil should work in most cases
-- 		cmd = nil,
-- 		-- the command arguments as a list
-- 		args = {},
-- 	},

-- 	view = {
-- 		-- width of the window, can be either a number (columns) or a string in `%`, for left or right side placement
-- 		width = 30,
-- 		-- height of the window, can be either a number (columns) or a string in `%`, for top or bottom side placement
-- 		height = 30,
-- 		-- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
-- 		side = "left",
-- 		-- if true the tree will resize itself after opening a file
-- 		auto_resize = false,
-- 		mappings = {
-- 			-- custom only false will merge the list with the default mappings
-- 			-- if true, it will only use your list to set the mappings
-- 			custom_only = false,
-- 			-- list of mappings to set on the tree manually
-- 			list = {},
-- 		},
-- 	},
-- })
require'nvim-tree'.setup {
  auto_reload_on_write = true,
  disable_netrw = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = true,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        -- user mappings go here
      },
    },
  },
  renderer = {
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = "open",
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
    },
  },
}

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

map("n", "<A-s>", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>r", ":NvimTreeRefresh<CR>", opts)
map("n", "<leader>n", ":NvimTreeFindFile<CR>", opts)
