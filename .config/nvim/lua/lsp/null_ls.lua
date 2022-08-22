local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

local on_attach = require("lsp/lsp_config").on_attach

null_ls.setup({
	on_attach = function(client)
		if client.server_capabilities.documentFormattingProvider then
			-- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({async = true})")
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
			on_attach()
		end
	end,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		-- null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.djhtml.with({
			extra_args = { "-t", "2" },
		}),
		null_ls.builtins.formatting.fish_indent,
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.shfmt,

		null_ls.builtins.diagnostics.flake8.with({
			extra_args = { "--max-line-length", "105", "--ignore", "E402,E501,E203" },
		}),
		-- null_ls.builtins.diagnostics.mypy,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.vint,
		null_ls.builtins.diagnostics.fish,

		null_ls.builtins.code_actions.gitsigns,
	},
})
