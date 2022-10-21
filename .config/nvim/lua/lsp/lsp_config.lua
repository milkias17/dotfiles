local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.keymap.set(...)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	--Enable completion triggered by <c-x><c-o>
	-- buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true, buffer = bufnr }

	buf_set_keymap("n", "K", vim.lsp.buf.hover, opts)
	buf_set_keymap("n", "gi", vim.lsp.buf.implementation, opts)
	buf_set_keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	buf_set_keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	buf_set_keymap("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	buf_set_keymap("n", "<space>D", vim.lsp.buf.type_definition, opts)
	buf_set_keymap("n", "<space>rn", vim.lsp.buf.rename, opts)
	buf_set_keymap("n", "<space>ca", vim.lsp.buf.code_action, opts)
	buf_set_keymap("n", "<space>e", vim.diagnostic.open_float, opts)
	buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, opts)
	buf_set_keymap("n", "]d", vim.diagnostic.goto_next, opts)

	buf_set_keymap("n", "gD", vim.lsp.buf.declaration, opts)
	buf_set_keymap("n", "gd", vim.lsp.buf.definition, opts)
	buf_set_keymap("n", "gr", vim.lsp.buf.references, opts)
	-- buf_set_keymap("n", "<leader>f", vim.lsp.buf.formatting, opts)
	buf_set_keymap("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)

	buf_set_keymap("n", "<C-s>", vim.lsp.buf.signature_help, opts)
	buf_set_keymap("i", "<C-s>", vim.lsp.buf.signature_help, opts)
	buf_set_keymap("n", "<space>q", vim.diagnostic.setloclist, opts)
	buf_set_keymap("n", "<space>ws", vim.lsp.buf.workspace_symbol, opts)
	-- buf_set_keymap("n", "<space>ds", vim.lsp.buf.document_symbol, opts)
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local M = {}
M.on_attach = on_attach
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

return M
