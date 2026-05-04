return {
	{
		"kristijanhusak/vim-dadbod-ui",
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_use_nvim_notify = 1
		end,
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		dependencies = {
			{ "tpope/vim-dadbod", cmd = "DB", lazy = true },
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		keys = {
			{ "<space>st", "<cmd>DBUIToggle<cr>", { noremap = true } },
			{ "<space>sa", "<cmd>DBUIAddConnection<cr>", { noremap = true } },
			{ "<space>sb", "<cmd>DBUIFindBuffer<cr>", { noremap = true } },
		},
	},
}
