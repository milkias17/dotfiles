-- local config = {
-- 	ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "python", "lua", "vim", "vimdoc" },
-- 	auto_install = true,
-- 	highlight = {
-- 		enable = true,
-- 		disable = function(lang, bufnr)
-- 			local max_filesize = 100 * 1024 -- 100 KB
-- 			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
-- 			return ok and stats and stats.size > max_filesize
-- 		end,
-- 		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
-- 		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
-- 		-- Using this option may slow down your editor, and you may see some duplicate highlights.
-- 		-- Instead of true it can also be a list of languages
-- 		-- additional_vim_regex_highlighting = { "html" },
-- 		-- additional_vim_regex_highlighting = { "python" },
-- 	},
-- 	indent = {
-- 		enable = true,
-- 		-- disable = { "python", "svelte", "html", "htmldjango" },
-- 	},
-- 	playground = {
-- 		enable = true,
-- 	},
-- 	incremental_selection = {
-- 		enable = true,
-- 		keymaps = {
-- 			init_selection = "gnn",
-- 			node_incremental = "gni",
-- 			scope_incremental = "gnc",
-- 			node_decremental = "gnm",
-- 		},
-- 	},
-- 	textobjects = {
-- 		select = {
-- 			enable = true,
-- 			lookahead = true,
-- 			keymaps = {
-- 				["af"] = "@function.outer",
-- 				["if"] = "@function.inner",
-- 				["ac"] = "@class.outer",
-- 				["ic"] = "@class.inner",
-- 			},
-- 		},
-- 		swap = {
-- 			enable = true,
-- 			swap_next = {
-- 				["<leader>sn"] = "@parameter.inner",
-- 			},
-- 			swap_previous = {
-- 				["<leader>sp"] = "@parameter.inner",
-- 			},
-- 		},
-- 		lsp_interop = {
-- 			enable = true,
-- 			border = "none",
-- 			peek_definition_code = {
-- 				["<leader>pf"] = "@function.outer",
-- 				["<leader>pc"] = "@class.outer",
-- 			},
-- 		},
-- 	},
-- 	move = {
-- 		enable = true,
-- 		set_jumps = true, -- whether to set jumps in the jumplist
-- 		goto_next_start = {
-- 			["]m"] = "@function.outer",
-- 			["]]"] = "@class.outer",
-- 		},
-- 		goto_next_end = {
-- 			["]M"] = "@function.outer",
-- 			["]["] = "@class.outer",
-- 		},
-- 		goto_previous_start = {
-- 			["[m"] = "@function.outer",
-- 			["[["] = "@class.outer",
-- 		},
-- 		goto_previous_end = {
-- 			["[M"] = "@function.outer",
-- 			["[]"] = "@class.outer",
-- 		},
-- 		goto_next = {
-- 			["]o"] = "@loop.*",
-- 			["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
-- 			["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
-- 			["]d"] = "@conditional.outer",
-- 		},
-- 		goto_previous = {
-- 			["[o"] = "@loop.*",
-- 			["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
-- 			["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
-- 			["[d"] = "@conditional.outer",
-- 		},
-- 	},
-- 	matchup = {
-- 		enable = true,
-- 	},
-- }

-- return {
-- 	{
-- 		"JoosepAlviste/nvim-ts-context-commentstring",
-- 		priority = 100,
-- 		config = function()
-- 			require("ts_context_commentstring").setup({
-- 				enable_autocmd = false,
-- 			})
-- 			vim.g.skip_ts_context_commentstring_module = 1
-- 		end,
-- 	},
-- 	{
-- 		"nvim-treesitter/nvim-treesitter",
-- 		build = ":TSUpdate",
--     branch = "master",
-- 		config = function()
-- 			require("nvim-treesitter.configs").setup(config)
-- 		end,
-- 		dependencies = {
-- 			{ "JoosepAlviste/nvim-ts-context-commentstring", priority = 100 },
-- 			{ "nvim-treesitter/nvim-treesitter-textobjects" },
-- 			{
-- 				"nvim-treesitter/nvim-treesitter-context",
-- 				config = true,
-- 				keys = {
-- 					{
-- 						"[c",
-- 						function()
-- 							require("treesitter-context").go_to_context(vim.v.count1)
-- 						end,
-- 						desc = "Next Context",
-- 					},
-- 				},
-- 			},
--
-- 			-- { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
-- 		},
-- 	},
-- 	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
-- }

local config = {
	install_dir = vim.fn.stdpath("data") .. "/site",
}

return {

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		branch = "main",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{
				"nvim-treesitter/nvim-treesitter-context",
				config = true,
				keys = {
					{
						"[c",
						function()
							require("treesitter-context").go_to_context(vim.v.count1)
						end,
						desc = "Next Context",
					},
				},
			},

			-- { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
		},
		config = function()
			require("nvim-treesitter").setup(config)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					-- 1. Ignore "Special" buffers (Harpoon, Telescope, Floats, Help, etc.)
					local buftype = vim.bo[args.buf].buftype
					if buftype ~= "" then
						return
					end

					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft) or ft

					-- 3. Optimization: Don't start Treesitter on massive files
					local max_filesize = 100 * 1024 -- 100 KB
					local ok_stats, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
					if ok_stats and stats and stats.size > max_filesize then
						return
					end

					-- 4. Final Check: Only start if a parser/query actually exists
					local has_query = pcall(vim.treesitter.query.get, lang, "highlights")
					if has_query then
						pcall(vim.treesitter.start, args.buf, lang)
					end
				end,
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		priority = 100,
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				move = {
					set_jumps = true,
				},
			})
			vim.keymap.set({ "x", "o" }, "am", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "im", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end)
			-- You can also use captures from other query groups like `locals.scm`
			vim.keymap.set({ "x", "o" }, "as", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
			end)

			-- keymaps
			vim.keymap.set("n", "<leader>sn", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>sp", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end)
			-- You can also pass a list to group multiple queries.
			vim.keymap.set({ "n", "x", "o" }, "]o", function()
				require("nvim-treesitter-textobjects.move").goto_next_start(
					{ "@loop.inner", "@loop.outer" },
					"textobjects"
				)
			end)
			-- You can also use captures from other query groups like `locals.scm` or `folds.scm`
			vim.keymap.set({ "n", "x", "o" }, "]s", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]z", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
			end)

			-- Go to either the start or the end, whichever is closer.
			-- Use if you want more granular movements
			vim.keymap.set({ "n", "x", "o" }, "]d", function()
				require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[d", function()
				require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
			end)
		end,
	},
}
