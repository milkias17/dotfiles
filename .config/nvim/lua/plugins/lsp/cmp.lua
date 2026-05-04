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

return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "1.*",

		dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim", "L3MON4D3/LuaSnip" },
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
