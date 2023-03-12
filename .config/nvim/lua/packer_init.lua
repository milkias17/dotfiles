local fn = vim.fn
local present, packer = pcall(require, "packer")

if not present then
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    print("Installing Packer")
    fn.delete(install_path, "rf")
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    present, packer = pcall(require, "packer")
    if present then
        print("Packer installed successfully!")
    else
        error("Couldn't install packer!\nInstall path: " .. install_path)
    end
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
    git = {
        clone_timeout = 120, -- Timeout, in seconds, for git clones
    },
})

vim.cmd([[ packadd packer.nvim ]])

return packer.startup(function(use)
    use("wbthomason/packer.nvim")
    use({
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    })

    --Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })
    use("nvim-treesitter/playground")
    use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
    use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" })
    -- use("windwp/nvim-autopairs")
    use("jiangmiao/auto-pairs")
    use("lukas-reineke/indent-blankline.nvim")
    use("windwp/nvim-ts-autotag")
    use({
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require("treesitter-context").setup()
        end,
    })
    use("fladson/vim-kitty")

    -- Lsp
    use("neovim/nvim-lspconfig")
    use("jose-elias-alvarez/null-ls.nvim")
    use("jose-elias-alvarez/typescript.nvim")

    use({
        "hrsh7th/nvim-cmp",
        after = "friendly-snippets",
    })
    use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
    use({ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" })
    use({ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" })
    use("mfussenegger/nvim-jdtls")
    use("napmn/react-extract.nvim")

    -- Debugging
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
    -- use({ "nvim-telescope/telescope-dap.nvim", requires = { "mfussenegger/nvim-dap" } })
    use("mfussenegger/nvim-dap-python")

    -- Snippets
    use({
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        after = "nvim-cmp",
    })
    use("rafamadriz/friendly-snippets")
    use({
        "dsznajder/vscode-es7-javascript-react-snippets",
        run = "yarn install --frozen-lockfile && yarn compile",
    })
    use({ "mattn/emmet-vim", ft = { "html", "javascript", "javascriptreact", "htmldjango", "svelte" } })

    -- Visual Stuff
    use("monsonjeremy/onedark.nvim")
    use("projekt0n/github-nvim-theme")
    use({ "catppuccin/nvim", as = "catppuccin" })
    use("marko-cerovac/material.nvim")
    use("NvChad/nvim-colorizer.lua")
    use("nvim-lualine/lualine.nvim")
    use("romgrk/barbar.nvim")
    use("kyazdani42/nvim-web-devicons")
    use("kyazdani42/nvim-tree.lua")

    -- Utils
    use("sindrets/diffview.nvim")
    use("tpope/vim-fugitive")
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    })
    use({
        "kylechui/nvim-surround",
        tag = "*",
    })
    use("numToStr/Comment.nvim")
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-lua/popup.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
            },
            {
                "nvim-telescope/telescope-media-files.nvim",
            },
        },
    })
    use({
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
            vim.keymap.set("n", "<space>nd", function()
                require("notify").dismiss()
            end, { silent = true, noremap = true })
        end,
    })

    use({ "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()", ft = { "markdown" } })
    -- use({ "tweekmonster/startuptime.vim", opt = true, cmd = { "StartupTime" } })
    use("dstein64/vim-startuptime")
    use("lewis6991/impatient.nvim")

    -- my_dev
    -- use(os.getenv("HOME") .. "/Dev/projects/neovim/reloader.nvim")
    use("rafcamlet/nvim-luapad")
    use({ "milkias17/reloader.nvim", requires = { { "nvim-lua/plenary.nvim" } } })

    -- Install plugins on first load
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
