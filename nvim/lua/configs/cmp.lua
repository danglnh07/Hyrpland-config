-- -- lua/configs/cmp.lua
-- local ok, cmp = pcall(require, "cmp")
-- if not ok then
--     return
-- end
--
-- -- safe luasnip require (NvChad usually includes it)
-- local has_luasnip, luasnip = pcall(require, "luasnip")
--
-- -- helper: is there a non-space char before cursor?
-- local has_words_before = function()
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     if col == 0 then return false end
--     local s = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
--     local char = s:sub(col, col)
--     return char:match("%s") == nil
-- end
--
-- -- try to read NvChad's default cmp config (if present)
-- local ok2, nv_cmp = pcall(require, "nvchad.configs.cmp")
-- local default_config = {}
-- local default_mapping = {}
-- if ok2 and type(nv_cmp) == "table" then
--     default_config = nv_cmp
--     default_mapping = nv_cmp.mapping or {}
-- end
--
-- -- our custom mappings
-- local custom_mapping = {
--     ["<Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--             cmp.select_next_item()
--         elseif has_luasnip and luasnip.expand_or_jumpable() then
--             luasnip.expand_or_jump()
--         else
--             fallback() -- insert a real tab
--         end
--     end, { "i", "s" }),
--
--     ["<S-Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--             cmp.select_prev_item()
--         elseif has_luasnip and luasnip.jumpable(-1) then
--             luasnip.jump(-1)
--         else
--             fallback()
--         end
--     end, { "i", "s" }),
--
--     ["<CR>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--             -- confirm selection when menu visible
--             cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
--         else
--             fallback() -- normal Enter (newline)
--         end
--     end, { "i", "s" }),
-- }
--
-- -- merge default mapping with our custom mapping (our keys override defaults)
-- local mapping = vim.tbl_extend("force", default_mapping, custom_mapping)
--
-- -- merge whole config (keep default keys like sources/snippet/formatting)
-- local final_config = vim.tbl_extend("force", default_config, { mapping = mapping })
--
-- -- apply the final config
-- cmp.setup(final_config)
--

-- ~/.config/nvim/lua/configs/cmp.lua
local ok, cmp = pcall(require, "cmp")
if not ok then return end

local has_luasnip, luasnip = pcall(require, "luasnip")

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then return false end
  local s = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  local char = s:sub(col, col)
  return char:match("%s") == nil
end

-- Build mapping from a clean preset so we don't accidentally keep broken defaults
local mapping = cmp.mapping.preset.insert({
  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<C-e>"] = cmp.mapping.abort(),
})

-- Tab behavior:
mapping["<Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif has_luasnip and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    -- insert a real tab (or trigger indent)
    fallback()
  end
end, { "i", "s" })

mapping["<S-Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif has_luasnip and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end, { "i", "s" })

-- Enter: confirm only if completion visible, else newline
mapping["<CR>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
  else
    fallback()
  end
end, { "i", "s" })

-- Try to reuse NvChad defaults (sources/snippet/formatting) but force our mapping
local ok2, nv_cmp = pcall(require, "nvchad.configs.cmp")
local base_config = {}
if ok2 and type(nv_cmp) == "table" then
  base_config = vim.deepcopy(nv_cmp)
  base_config.mapping = nil -- ensure we overwrite mapping completely
end

local final = vim.tbl_extend("force", base_config, {
  mapping = mapping,
})

cmp.setup(final)

