local plugins = {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "gopls",
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy", -- or "BufReadPre" to load earlier
        config = function()
            require "configs.null-ls"
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Load NvChad's defaults first
            require("nvchad.configs.lspconfig").defaults()

            -- Then load your custom LSP setups
            require "configs.lspconfig"
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require "configs.nvimtree"
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            -- let NvChad defaults load first (safe)
            pcall(require, "nvchad.configs.cmp")
            -- then apply our override that merges with defaults
            require "configs.cmp"
        end,
    },
    {
        "aklt/plantuml-syntax",
        ft = { "puml", "plantuml" },
    },
}

return plugins
