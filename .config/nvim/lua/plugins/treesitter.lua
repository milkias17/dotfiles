local config = {
	ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "python", "lua", "vim", "vimdoc" },
	auto_install = true,
	highlight = {
		enable = true,
		disable = function(lang, bufnr)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
			return ok and stats and stats.size > max_filesize
		end,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		-- additional_vim_regex_highlighting = { "html" },
		additional_vim_regex_highlighting = { "svelte", "python" },
	},
	indent = {
		enable = true,
		disable = { "python", "svelte", "html", "htmldjango" },
	},
	playground = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "gni",
			scope_incremental = "gnc",
			node_decremental = "gnm",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>sn"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>sp"] = "@parameter.inner",
			},
		},
		lsp_interop = {
			enable = true,
			border = "none",
			peek_definition_code = {
				["<leader>pf"] = "@function.outer",
				["<leader>pc"] = "@class.outer",
			},
		},
	},
	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = "@class.outer",
		},
		goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		},
		goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		},
		goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		},
		goto_next = {
			["]o"] = "@loop.*",
			["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
			["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
			["]d"] = "@conditional.outer",
		},
		goto_previous = {
			["[o"] = "@loop.*",
			["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
			["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
			["[d"] = "@conditional.outer",
		},
	},
	matchup = {
		enable = true,
	},
}

return {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		priority = 100,
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
			vim.g.skip_ts_context_commentstring_module = 1
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup(config)
		end,
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring", priority = 100 },
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{
				"nvim-treesitter/nvim-treesitter-context",
				config = true,
			},
		},
	},
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
}
