local lsp_icons = {
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}

local codicons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local function border(hl_name)
	return {
		{ "╭", hl_name },
		{ "─", hl_name },
		{ "╮", hl_name },
		{ "│", hl_name },
		{ "╯", hl_name },
		{ "─", hl_name },
		{ "╰", hl_name },
		{ "│", hl_name },
	}
end

local cmp_config = function()
	local cmp = require("cmp")
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
	return {
		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = {
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
			["<C-c>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<C-e>"] = cmp.config.disable,
			-- Accept currently selected item. If none selected, `select` first item.
			-- Set `select` to `false` to only confirm explicitly selected items.
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end,
			["<S-Tab>"] = cmp.mapping.select_prev_item(),
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				-- Lsp icons
				vim_item.kind = string.format("%s", lsp_icons[vim_item.kind])
				vim_item.menu = ({
					nvim_lsp = "[LSP]",
					luasnip = "[Snippet]",
					buffer = "[Buffer]",
					path = "[Path]",
					rg = "[Project]",
				})[entry.source.name]
				-- vim_item.menu = ({
				-- 	nvim_lsp = "",
				-- 	luasnip = "",
				-- 	buffer = "ﮜ",
				-- 	path = "",
				-- })[entry.source.name]
				return vim_item
			end,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "nvim_lua" },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						local buf = vim.api.nvim_get_current_buf()
						local line_size = vim.api.nvim_buf_line_count(buf)
						if line_size > 350 then
							return {}
						end
						-- local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
						-- if byte_size > 1024 * 1024 then -- 1 Megabyte max
						-- 	return {}
						-- end
						return { buf }
					end,
				},
			},
		}, {
			{ name = "path" },
			-- {
			-- 	name = "rg",
			-- 	option = {
			-- 		get_bufnrs = function()
			-- 			local max_filesize = 1024 * 1024
			-- 			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
			-- 			return ok and stats and stats.size < max_filesize
			-- 		end,
			-- 	},
			-- },
		}),

		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "cmp_git" },
			}),
		}),

		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		experimental = {
			ghost_text = true,
		},
	}
end

return {
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	version = false,
	-- 	dependencies = {
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-buffer",
	-- 		"hrsh7th/cmp-path",
	-- 		"saadparwaiz1/cmp_luasnip",
	-- 		-- "hrsh7th/cmp-nvim-lsp-signature-help",
	-- 		{ "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim" },
	-- 		"lukas-reineke/cmp-rg",
	-- 		"hrsh7th/cmp-nvim-lua",
	-- 	},
	-- 	opts = cmp_config,
	-- 	event = "InsertEnter",
	-- },
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "*",

		dependencies = { "L3MON4D3/LuaSnip" },
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				-- ["<C-y>"] = { "select_and_accept" },
				["<c-j>"] = {},
				["<c-k>"] = {},
				["<Tab>"] = {},
				["<S-Tab>"] = {},
			},
			snippets = {
				preset = "luasnip",
			},
			completion = {
				menu = {
					border = "rounded",
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
					},
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline"
					end,
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},

				ghost_text = {
					enabled = true,
				},
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				kind_icons = lsp_icons,
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "dadbod" },
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
			cmdline = {},
			-- experimental signature help support
			signature = { enabled = true },
		},
	},
}
