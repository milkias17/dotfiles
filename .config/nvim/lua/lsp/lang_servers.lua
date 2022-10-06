local capabilities = require("lsp/lsp_config").capabilities
local on_attach = require("lsp/lsp_config").on_attach
local lspconfig = require("lspconfig")

lspconfig.html.setup({
	flags = { debounce_text_changes = 500 },
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		-- client.resolved_capabilities.document_formatting = false
	end,
	capabilities = capabilities,
	filetypes = { "html", "htmldjango" },
})

if not lspconfig.emmet_ls then
	require("lspconfig/configs").emmet_ls = {
		default_config = {
			cmd = { "emmet-ls", "--stdio" },
			filetypes = { "html", "css", "htmldjango" },
			settings = {},
		},
	}
end
lspconfig.emmet_ls.setup({
	capabilities = capabilities,
	flags = { debounce_text_changes = 500 },
	filetypes = { "html", "css", "htmldjango" },
})

lspconfig.tsserver.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		-- client.resolved_capabilities.document_formatting = false
		on_attach(client, bufnr)
	end,
	flags = { debounce_text_changes = 500 },
	root_dir = function()
		return vim.loop.cwd()
	end,
	capabilities = capabilities,
})

lspconfig.sumneko_lua.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				-- path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "awesome" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = { enable = false },
		},
	},
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		-- client.resolved_capabilities.document_formatting = false
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
})

-- lspconfig.jedi_language_server.setup({ on_attach = on_attach })

lspconfig.pyright.setup({
	on_attach = on_attach,
	root_dir = function()
		return vim.loop.cwd()
	end,

	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = false,
				typeCheckingMode = "off",
			},
		},
	},
	capabilities = capabilities,
	single_file_support = true,
})

lspconfig.clangd.setup({
	capabilities = capabilities,
	on_attach = function()
		on_attach()
		-- if client.server_capabilities.documentFormattingProvider then
		-- 	vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
		-- 	on_attach()
		-- end
	end,
	root_dir = function()
		return vim.loop.cwd()
	end,
})

lspconfig.dockerls.setup({})
