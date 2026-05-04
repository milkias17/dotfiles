local opts = { noremap = true, silent = true }

return {
	{ "fladson/vim-kitty" },

	-- Lsp
	{ "mfussenegger/nvim-jdtls", ft = "java" },

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
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		-- @type snacks.Config
		opts = {
			image = { enabled = true },
			input = { enabled = true },
			indent = { enabled = true, only_current = true },
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

	{
		"xeluxee/competitest.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		config = function()
			require("competitest").setup({
				received_contests_directory = "$(HOME)/Dev/competitive-programming/$(JUDGE)/$(CONTEST)",
			})
		end,
		cmd = { "CompetiTest" },
		keys = {
			{ "<space>cr", "<cmd>CompetiTest run<cr>", opts },
			{ "<space>ctp", "<cmd>CompetiTest receive problem<cr>", opts },
			{ "<space>ctc", "<cmd>CompetiTest receive contest<cr>", opts },
		},
	},
}
