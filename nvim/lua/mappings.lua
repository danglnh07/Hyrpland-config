require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local M = {}

M.general = {
    n = {
        ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find files" },
        ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
        ["<leader>e"] = { "<cmd>NvimTreeToggle<cr>", "Toggle file tree" },
    },
}

return M
