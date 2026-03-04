return {
  {
    "mason-org/mason.nvim", -- Ensure using the standard plugin name
    opts = function(_, opts)
      opts.registries = {
        "github:mason-org/mason-registry", -- REQUIRED: Official core registry
        "github:Crashdummyy/mason-registry", -- Custom registry for Roslyn
      }
    end,
  },

  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "cshtml", "csproj", "razor" },
    opts = {},
    config = function(_, opts)
      require("roslyn").setup(opts)

      local function make_virtual_buf_modifiable(buf)
        if vim.api.nvim_buf_is_valid(buf) then
          vim.bo[buf].modifiable = true
        end
      end

      for _, event in ipairs({ "BufNew", "BufAdd", "BufWinEnter", "BufReadPre" }) do
        vim.api.nvim_create_autocmd(event, {
          pattern = "*__virtual.html",
          callback = function(ev)
            make_virtual_buf_modifiable(ev.buf)
          end,
        })
      end

      -- Also patch any existing buffers immediately
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf):match("__virtual%.html$") then
          make_virtual_buf_modifiable(buf)
        end
      end
    end,
  },
}
