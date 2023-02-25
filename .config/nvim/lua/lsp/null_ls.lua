local status, null_ls = pcall(require, "null-ls")
if not status then
	vim.notify("Null LS not installed")
	return
end

local on_attach = require("lsp.lsp_config").on_attach

local function get_sources()
	local sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.djhtml.with({
			extra_args = { "-t", "2" },
		}),

		null_ls.builtins.formatting.prettierd.with({
			extra_filetypes = { "svelte" },
		}),
		null_ls.builtins.formatting.fish_indent,
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.shfmt,

		-- null_ls.builtins.diagnostics.djlint,
		-- null_ls.builtins.diagnostics.mypy,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.vint,
		null_ls.builtins.diagnostics.fish,
		null_ls.builtins.code_actions.gitsigns,

		require("typescript.extensions.null-ls.code-actions"),
	}

	if vim.fn.filereadable(".eslintrc.js") == 1 or vim.fn.filereadable(".eslintrc.cjs") == 1 then
		table.insert(sources, null_ls.builtins.formatting.eslint_d)
		table.insert(
			sources,
			null_ls.builtins.diagnostics.eslint_d.with({
				extra_filetypes = { "svelte" },
			})
		)
		table.insert(
			sources,
			null_ls.builtins.code_actions.eslint_d.with({
				extra_filetypes = { "svelte" },
			})
		)
	end

	if
		vim.fn.filereadable(".prettierrc") == 1 and not vim.tbl_contains(sources, null_ls.builtins.formatting.prettierd)
	then
		table.insert(
			sources,
			null_ls.builtins.formatting.prettier.with({
				extra_filetypes = { "svelte" },
			})
		)
	end

	local current_dir = vim.fn.getcwd()
	if string.find(current_dir, "ALX") == nil then
		table.insert(sources, null_ls.builtins.formatting.black)
		table.insert(
			sources,
			null_ls.builtins.diagnostics.flake8.with({
				extra_args = { "--max-line-length", "88", "--ignore", "E203,E266,E501,W503" },
			})
		)
	else
		table.insert(sources, null_ls.builtins.formatting.autopep8)
		table.insert(sources, null_ls.builtins.diagnostics.pycodestyle)
	end

	return sources
end

null_ls.setup({
	on_attach = function(client)
		if client.server_capabilities.documentFormattingProvider then
			-- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
			-- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
			on_attach()
		end
	end,
	sources = get_sources(),
})
