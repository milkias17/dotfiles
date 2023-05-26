local status, null_ls = pcall(require, "null-ls")
if not status then
	vim.notify("Null LS not installed")
	return
end

local on_attach = require("lsp.lsp_config").on_attach

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
