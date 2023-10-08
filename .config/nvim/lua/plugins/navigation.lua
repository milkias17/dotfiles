local config = {
  hijack_cursor = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  view = {
    width = "25%",
    number = true,
    relativenumber = true,
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
  diagnostics = {
    enable = true,
  },
  modified = {
    enable = true,
  },
  filesystem_watchers = {
    enable = true,
  },
}

local function neo_config()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  local opts = {
    window = {
      mappings = {
        ["<tab>"] = function(state)
          state.commands["open"](state)
          vim.cmd("Neotree reveal")
        end,
      },
    },
    filesystem = {
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "disabled",
      follow_current_file = true,
    },
  }

  require("neo-tree").setup(opts)
end

local opts = { noremap = true, silent = true }

return {
  -- {
  -- 	"nvim-tree/nvim-tree.lua",
  -- 	version = "*",
  -- 	dependencies = {
  -- 		"nvim-tree/nvim-web-devicons",
  -- 	},
  -- 	keys = {
  -- 		{ "<A-s>", "<cmd>NvimTreeToggle<cr>", opts },
  -- 	},
  -- 	opts = config,
  -- 	lazy = false,
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = neo_config,
    keys = {
      { "<A-s>", "<cmd>Neotree toggle<cr>", opts },
    },
    lazy = false,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
