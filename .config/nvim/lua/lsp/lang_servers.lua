local lsp_config = require("lsp.lsp_config")
local capabilities = lsp_config.capabilities
local on_attach = lsp_config.on_attach
local lspconfig = require("lspconfig")

-- Use loop for calling servers requiring no configuration
local servers = { "bashls" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		root_dir = function()
			return vim.loop.cwd()
		end,
		capabilities = capabilities,
	})
end

lspconfig.html.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		-- client.resolved_capabilities.document_formatting = false
	end,
	capabilities = capabilities,
	filetypes = { "html", "htmldjango" },
})

if vim.fn.filereadable("tailwind.config.cjs") == 0 then
    lspconfig.cssls.setup({
        on_attach = on_attach,
        root_dir = function ()
            return vim.loop.cwd()
        end,
        capabilities = capabilities
    })

end
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
	filetypes = { "html", "css", "htmldjango" },
})

lspconfig.tsserver.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		-- client.resolved_capabilities.document_formatting = false
		on_attach(client, bufnr)
	end,
	root_dir = function()
		return vim.loop.cwd()
	end,
	capabilities = capabilities,
})

require("typescript").setup({
	server = {
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	},
})

lspconfig.svelte.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig.tailwindcss.setup({
    capabilities = capabilities
})

lspconfig.prismals.setup({
    capabilities = capabilities
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
		-- end
	end,
	root_dir = function()
		return vim.loop.cwd()
	end,
})

lspconfig.dockerls.setup({})
