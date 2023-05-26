return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			{
				"dsznajder/vscode-es7-javascript-react-snippets",
				build = "yarn install --frozen-lockfile && yarn compile",
			},
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip/loaders/from_vscode").lazy_load()
					require("luasnip/loaders/from_vscode").lazy_load({
						paths = { "/home/mike/.config/nvim/my-snippets" },
					})
				end,
			},
		},
		config = function()
			require("lsp.snippets")
		end,
		keys = {
			{
				"<c-k>",
				function()
					if require("luasnip").expand_or_jumpable() then
						require("luasnip").expand_or_jump()
					end
				end,
				silent = true,
				mode = { "i", "s" },
			},
			{
				"<c-j>",
				function()
					if require("luasnip").jumpable(-1) then
						require("luasnip").jump(-1)
					end
				end,
				silent = true,
				mode = { "i", "s" },
			},
			{
				"<c-l>",
				function()
					if require("luasnip").choice_active() then
						require("luasnip").change_choice(1)
					end
				end,
        silent = true,
        mode = "i"
			},
      {
        "<M-u>",
        function ()
          require("luasnip.extras.select_choice")
        end,
        mode = "i"
      }
		},
	},
}
