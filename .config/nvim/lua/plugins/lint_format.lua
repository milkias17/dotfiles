local formatters = {
	lua = { "stylua" },
	htmldjango = { "djlint" },
	-- ["svelte,typescript,javascript,javascriptreact,typescriptreact,html,css"] = { "prettierd" },
	-- ["javascript,javascriptreact,typescript,typescriptreact"] = { "biome" },
	-- ["svelte,html,css"] = { "prettierd" },
	-- ["javascript,javascriptreact,typescript,typescriptreact"] = { "eslint_d" },
	-- python = { "isort", "black", "autoflake" },
	-- python = { "ruff_format" },
	fish = { "fish_indent" },
	json = { "fixjson" },
	sh = { "shfmt" },
	markdown = { "mdformat" },
	sql = { "sql_formatter" },
	-- go = { "injected" },
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
		config = function()
			local lint = require("lint")
			local flake8 = require("lint").linters.flake8
			flake8.args = {
				"--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
				"--no-show-source",
				"--max-line-length=120",
				-- "--ignore=E203,E266,E501,W503",
				"-",
			}

			local linters_by_ft = {
				fish = { "fish" },
				-- python = { "ruff", "flake8" },
				htmldjango = { "djlint" },
			}

			lint.linters_by_ft = linters_by_ft

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
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
		config = function()
			require("conform").formatters.autoflake = {
				prepend_args = { "--remove-all-unused-imports" },
			}
			require("conform").setup({
				formatters_by_ft = get_formatters(formatters),
			})
			require("conform").formatters.injected = {
				options = {
					lang_to_ext = {
						bash = "sh",
						c_sharp = "cs",
						elixir = "exs",
						javascript = "js",
						julia = "jl",
						latex = "tex",
						markdown = "md",
						python = "py",
						ruby = "rb",
						rust = "rs",
						teal = "tl",
						typescript = "ts",
						sql = "sql",
					},
				},
			}
		end,
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
