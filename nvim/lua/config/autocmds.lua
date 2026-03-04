-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- bootstrap lazy.nvim, LazyVim and your plugins
vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
  pattern = {
    [".*%.cshtml"] = "razor",
    [".*%.razor"] = "razor",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "razor",
  callback = function()
    -- Use HTML parser for Razor files as fallback
    vim.treesitter.language.register("html", "razor")
  end,
})

-- In ~/.config/nvim/lua/config/autocmds.lua

-- Prevent __virtual.html files from being marked as modified or saved
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
  pattern = "*__virtual*.html",
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].buftype = "nofile"
    vim.bo[bufnr].bufhidden = "hide"
    vim.bo[bufnr].swapfile = false
    vim.bo[bufnr].modified = false
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].buflisted = false
  end,
})
--
-- Also catch any modifications to these files
vim.api.nvim_create_autocmd("BufModifiedSet", {
  pattern = "*__virtual*.html",
  callback = function(args)
    vim.bo[args.buf].modified = false
  end,
})

-- Treesitter and performance for Razor
vim.api.nvim_create_autocmd("FileType", {
  pattern = "razor",
  callback = function(args)
    local bufnr = args.buf
    vim.treesitter.language.register("html", "razor")
    vim.opt_local.updatetime = 2000
    vim.b[bufnr].semantic_tokens_enabled = false
  end,
})
