if not pcall(require, "lspconfig") then
	return
end

require("lsp/lsp_config")
require("lsp/lang_servers")
require("lsp/cmp_config")
require("lsp/null_ls")
