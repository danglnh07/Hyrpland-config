return {
  "3rd/image.nvim",
  opts = {
    -- your options here
    -- e.g., enable on startup
    -- enable_nvim_notify = true, -- optional, if you want notifications
    -- enable_opener = true, -- optional, to open image with an external app
  },
  config = function(_, opts)
    require("image").setup(opts)
  end,
}
