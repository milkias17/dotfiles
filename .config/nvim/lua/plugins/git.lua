-- vim.env.NEOGIT_LOG_FILE = false
-- vim.env.NEOGIT_LOG_LEVEL = "debug"
local neogit_opts = {
	-- kind = "split_above",
	kind = "split",
	disable_commit_confirmation = true,
	disable_builtin_notifications = true,
	disable_insert_on_commit = "auto",
	commit_editor = {
		kind = "split",
	},
	graph_style = "kitty",
}
--
local opts = { noremap = true, silent = true }
--

local gitsigns_opts = {
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then
				return "]h"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[h", function()
			if vim.wo.diff then
				return "[h"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map("n", "<leader>hs", gs.stage_hunk)
		map("n", "<leader>hr", gs.reset_hunk)
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("n", "<leader>hS", gs.stage_buffer)
		map("n", "<leader>hu", gs.undo_stage_hunk)
		map("n", "<leader>hR", gs.reset_buffer)
		map("n", "<leader>hp", gs.preview_hunk)
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<leader>tb", gs.toggle_current_line_blame)
		map("n", "<leader>hd", gs.diffthis)
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end)
		map("n", "<leader>td", gs.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
}

return {
	{
		"wintermute-cell/gitignore.nvim",
		cmd = { "Gitignore" },
	},
	{
		"NeogitOrg/neogit",
		-- dir = "~/Dev/projects/neovim/neogit",
		opts = neogit_opts,
		keys = {
			{
				"<space>ng",
				function()
					require("neogit").open()
				end,
				opts,
			},
		},
		cmd = { "Neogit" },
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		event = { "BufReadPre", "BufNewFile" },
		opts = gitsigns_opts,
	},
	{
		"sindrets/diffview.nvim",
		config = true,
		lazy = true,
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
			"DiffviewFileHistory",
		},
		keys = {
			{
				"<space>do",
				mode = "n",
				"<cmd>DiffviewOpen<cr>",
			},
      {
        "<space>dc",
        mode = "n",
        "<cmd>DiffviewClose<cr>",
      }
		},
	},
	-- {
	-- 	"SuperBo/fugit2.nvim",
	-- 	opts = {
	-- 		width = 70,
	-- 		external_diffview = true, -- tell fugit2 to use diffview.nvim instead of builtin implementation.
	-- 	},
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 		"nvim-lua/plenary.nvim",
	-- 		{
	-- 			"chrisgrieser/nvim-tinygit", -- optional: for Github PR view
	-- 		},
	-- 	},
	-- 	cmd = { "Fugit2", "Fugit2Blame", "Fugit2Diff", "Fugit2Graph" },
	-- 	keys = {
	-- 		{ "<leader>F", mode = "n", "<cmd>Fugit2<cr>" },
	-- 	},
	-- },
}
