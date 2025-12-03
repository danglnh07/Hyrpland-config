return {
    {
        "3rd/image.nvim",
        event = "VeryLazy",
        opts = {
            backend = "kitty", -- Explicitly set the backend for optimal compatibility
            -- You can add other options here:
            -- max_width = 100,
            -- max_height = 50,
            -- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
        },
        config = function(_, opts)
            require("image").setup(opts)
        end,
    },
}
