local formatters = {
	lua = { "stylua" },
	htmldjango = { "djlint" },
	["svelte,typescript,javascript,javascriptreact,typescriptreact"] = { "prettierd" },
	python = { "isort", "black", "autoflake" },
	fish = { "fish_indent" },
	json = { "fixjson" },
	sh = { "shfmt" },
}

local function add_formatter(ft, formatter, formatter_table)
	if formatter_table[ft] == nil then
		formatter_table[ft] = formatter
	else
		for _, f in ipairs(formatter) do
			table.insert(formatter_table[ft], f)
		end
	end
end

local function get_formatters(formatters)
	local formatters_by_ft = {}
	for ft, formatter in pairs(formatters) do
		if vim.split(ft, ",") then
			for _, f in ipairs(vim.split(ft, ",")) do
				add_formatter(f, formatter, formatters_by_ft)
			end
		else
			add_formatter(ft, formatter, formatters_by_ft)
		end
	end
	return formatters_by_ft
end

return {
	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		opts = {
			events = { "BufReadPre", "BufNewFile" },
			linters_by_ft = {
				fish = { "fish" },
				python = { "flake8" },
			},
		},
		config = function(_, opts)
			local lint = require("lint")
			lint.linters_by_ft = opts.linters_by_ft

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave", "TextChanged" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = get_formatters(formatters),
		},
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
			},
		},
	},
}
