local opts = { noremap = true, silent = true }

return {
	{ "fladson/vim-kitty" },

	-- Lsp
	{ "mfussenegger/nvim-jdtls", ft = "java" },

	-- Debugging
	-- { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	-- { "nvim-telescope/telescope-dap.nvim", dependencies = { "mfussenegger/nvim-dap" } },
	-- "mfussenegger/nvim-dap-python",

	{ "nvim-lua/plenary.nvim", lazy = true, branch = "master" },
	{ "nvim-lua/popup.nvim", lazy = true },
	{
		"iamcco/markdown-preview.nvim",
		build = ":call mkdp#util#install()",
		ft = { "markdown" },
		cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
	},
	{ "dstein64/vim-startuptime", cmd = "StartupTime" },
	{
		"CRAG666/code_runner.nvim",
		opts = {
			filetype = {
				go = "go run",
			},
		},
		cmd = { "RunCode", "RunFile", "RunProject" },
		keys = {
			{
				"<leader>r",
				"<cmd>RunCode<CR>",
				noremap = true,
				silent = true,
			},
		},
	},
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
	},
	{
		"wakatime/vim-wakatime",
		event = "VeryLazy",
	},
	{
		"mistricky/codesnap.nvim",
		build = "make",
		cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight", "CodeSnapSaveHighligh", "CodeSnapASCII" },
		opts = {
			has_breadcrumbs = true,
			save_path = "~/Pictures/Code_Snap",
			watermark = "",
			bg_color = "#535c68",
			has_line_number = true,
		},
	},
	-- {
	-- 	"akinsho/toggleterm.nvim",
	-- 	version = "*",
	-- 	opts = {
	-- 		open_mapping = [[<c-\>]],
	-- 		insert_mappings = true,
	-- 		shell = "fish",
	-- 	},
	-- 	cmd = { "ToggleTerm", "ToggleTermToggleAll" },
	-- 	event = "VeryLazy",
	-- },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		-- @type snacks.Config
		opts = {
			input = { enabled = true },
			indent = { enabled = true },
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			rename = {
				enabled = true,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions[1].type == "move" then
						Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
					end
				end,
			})
		end,
		keys = {
			{
				"<space>ns",
				function()
					Snacks.notifier.hide()
				end,
				opts,
			},
			{
				"<space>nh",
				function()
					Snacks.notifier.show_history()
				end,
				opts,
			},
			{
				"<space>.",
				function()
					Snacks.scratch()
				end,
			},
		},
	},
}
