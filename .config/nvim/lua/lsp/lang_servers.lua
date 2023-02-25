local lsp_config = require("lsp.lsp_config")
local capabilities = lsp_config.capabilities
local on_attach = lsp_config.on_attach
local lspconfig = require("lspconfig")

local function setup_server(config_name, opts, no_default)
    if no_default then
        lspconfig[config_name].setup(opts)
    end

    local default_opts = {
        on_attach = on_attach,
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

-- Use loop for calling servers requiring no configuration
local servers = { "bashls", "clangd" }

setup_server("html", {
    filetypes = { "html", "htmldjango" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
    end,
})

if vim.fn.filereadable("tailwind.config.cjs") == 0 then
    setup_server("cssls")
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

setup_server("emmet_ls", {
    filetypes = { "html", "css", "htmldjango" },
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

setup_server("svelte")

setup_server("tailwindcss", {
    capabilities = capabilities,
    root_dir = function(fname)
        return require("lspconfig.util").root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
            or require("lspconfig.util").root_pattern("postcss.config.js", "postcss.config.ts")(fname)
    end,
}, true)

setup_server("prismals", {
    capabilities = capabilities,
}, true)

setup_server("lua_ls", {
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
})

-- setup_server("jedi_language_server")

setup_server("pyright", {
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
    single_file_support = true,
})

setup_server("dockerls", {}, true)

for _, lsp in ipairs(servers) do
    setup_server(lsp)
end
