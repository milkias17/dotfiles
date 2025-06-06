local lspconfig = require("lspconfig")
local lsp_config = require("lsp.lsp_config")
local capabilities = lsp_config.capabilities
local on_attach = lsp_config.on_attach

local function is_theme_directory_present()
	local function directory_exists(dir)
		local ok, _, code = os.rename(dir, dir)
		if not ok then
			if code == 13 then
				-- Permission denied, but it exists
				return true
			end
		end
		return ok
	end
	return directory_exists("theme")
end

local function setup_server(config_name, opts, override_default)
	if override_default then
		lspconfig[config_name].setup(opts)
		return
	end

	local default_opts = {
		root_dir = function()
			return vim.loop.cwd()
		end,
		capabilities = capabilities,
	}

	if opts == nil or vim.tbl_count(opts) == 0 then
		lspconfig[config_name].setup(default_opts)
	else
		lspconfig[config_name].setup(vim.tbl_deep_extend("force", default_opts, opts))
	end
end

local servers = {
	"bashls",
	"gopls",
	{
		name = "html",
		opts = function()
			local html_capabilities = vim.lsp.protocol.make_client_capabilities()
			html_capabilities.textDocument.completion.completionItem.snippetSupport = true
			return {
				filetypes = { "html", "htmldjango" },
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
				end,
				capabilities = html_capabilities,
			}
		end,
	},
	{
		name = "clangd",
		opts = function()
			local clangd_capabilities = capabilities
			clangd_capabilities.offsetEncoding = "utf-8"
			return {
				capabilities = clangd_capabilities,
			}
		end,
	},
	{
		name = "svelte",
		opts = function()
			local svelte_capabilities = vim.lsp.protocol.make_client_capabilities()
			svelte_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
			return {
				capabilities = svelte_capabilities,
			}
		end,
	},
	{
		name = "tailwindcss",
		opts = {
			capabilities = capabilities,
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern(
					"tailwind.config.js",
					"tailwind.config.ts",
					"tailwind.config.cjs"
				)(fname) or require("lspconfig.util").root_pattern(
					"postcss.config.js",
					"postcss.config.ts",
					"postcss.config.cjs"
				)(fname) or require("lspconfig.util").root_pattern("theme")(fname)
			end,
			settings = {
				tailwindCSS = {
					experimental = {
						classRegex = {
							{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						},
					},
				},
			},
		},
		override_default = true,
	},
	{
		name = "prismals",
		opts = {
			capabilities = capabilities,
		},
		override_default = true,
	},
	{
		name = "lua_ls",
		opts = {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						checkThirdParty = false,
						library = {
							-- vim.env.VIMRUNTIME,
							-- "$XDG_DATA_HOME/nvim/lazy",
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
					},
				},
			},
		},
	},
	{
		name = "pyright",
		disable = false,
		opts = {
			settings = {
				python = {
					analysis = {
						-- autoSearchPaths = false,
						-- diagnosticMode = "openFilesOnly",
						-- useLibraryCodeForTypes = false,
						typeCheckingMode = "off",
					},
				},
			},
			-- single_file_support = true,
		},
	},
	{
		name = "basedpyright",
		disable = true,
		opts = {
			settings = {
				python = {
					analysis = {
						-- autoSearchPaths = true,
						-- diagnosticMode = "workspace",
						-- useLibraryCodeForTypes = false,
						typeCheckingMode = "off",
					},
				},
			},
			single_file_support = true,
		},
	},
	{
		name = "pylsp",
		disable = true,
		opts = {
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {
							enabled = false,
						},
						autopep8 = {
							enabled = false,
						},
						flake8 = {
							enabled = false,
						},
						pylint = {
							enabled = false,
						},
					},
				},
			},
		},
	},
  -- "ruff",
	{
		name = "dockerls",
		opts = {},
		override_default = true,
	},
	{
		name = "docker_compose_language_service",
		opts = {},
		override_default = true,
	},
	{
		name = "efm",
		opts = {
			cmd = { "efm-langserver", "-c", os.getenv("HOME") .. "/.config/nvim/lua/lsp/efm-config.yml" },
			init_options = { documentFormatting = true },
		},
		override_default = true,
		disable = true,
	},
	{
		name = "jedi_language_server",
		opts = {},
		override_default = true,
		disable = true,
	},
	{
		name = "pylyzer",
		opts = {},
		override_default = true,
		disable = true,
	},
	{
		name = "cssls",
		opts = {},
		-- cond = function()
		--   return vim.fn.filereadable("tailwindcss.config.cjs") == 0
		-- end,
	},
	{
		name = "emmet_ls",
		disable = true,
		opts = {
			filetypes = { "html", "css" },
		},
		disable = true,
	},
	{
		name = "emmet_language_server",
		disable = true,
	},
	{
		name = "tsserver",
		disable = true,
	},
	{
		name = "vtsls",
		disable = false,
		opts = {
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
			},
		},
	},
	{
		name = "biome",
	},
	"phpactor",
	{
		name = "jsonls",
		opts = {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas({
						select = {
							".eslintrc",
							"prettierrc.json",
							"tsconfig.json",
							"package.json",
						},
					}),
					validate = { enable = true },
				},
			},
		},
	},
	{
		name = "yamlls",
		opts = {
			settings = {
				yaml = {
					validate = true,
				},
			},
		},
	},
	{ name = "taplo", override_default = true, opts = {
		cmd = { "taplo", "lsp", "stdio" },
	} },
	"asm_lsp",
}

for _, lsp in ipairs(servers) do
	if type(lsp) == "string" then
		setup_server(lsp)
		goto continue
	end
	if type(lsp) ~= "table" then
		error("Invalid lsp config")
	end

	if lsp.disable or (lsp.cond ~= nil and lsp.cond() == true) then
		goto continue
	end

	local name, opts, override_default = lsp.name, lsp.opts, lsp.override_default
	if type(opts) == "function" then
		opts = opts()
	end

	if override_default then
		setup_server(name, opts, override_default)
	else
		setup_server(name, opts)
	end
	::continue::
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		-- local buffer = args.buf
		-- local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- This is svelte specifc configuration, probably fixed by 0.10, TODO: check
		-- vim.api.nvim_create_autocmd("BufWritePost", {
		-- 	pattern = { "*.js", "*.ts" },
		-- 	callback = function(ctx)
		-- 		if client.name == "svelte" then
		-- 			client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
		-- 		end
		-- 	end,
		-- })
		on_attach(args)
		for _, client in pairs((vim.lsp.get_clients({}))) do
			if client.name == "tailwindcss" then
				client.server_capabilities.completionProvider.triggerCharacters =
					{ '"', "'", "`", ".", "(", "[", "!", "/", ":" }
			end
		end
	end,
})
