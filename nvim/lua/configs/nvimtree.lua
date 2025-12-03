local nvchad_nvtree = require "nvchad.configs.nvimtree"

require("nvim-tree").setup({
  filters = {
    dotfiles = false,  -- show dotfiles
  },
  git = {
    enable = true,
    ignore = false,    -- don’t hide files in .gitignore
  },
})

