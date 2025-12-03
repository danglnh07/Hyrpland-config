local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup {
    -- Add root_dir configuration to prioritize project-specific markers
    root_dir = require("null-ls.utils").root_pattern(
    -- Python project markers (highest priority)
        "pyproject.toml",
        "setup.py",
        "requirements.txt",
        -- Go project markers
        "go.mod",
        "go.work",
        -- Generic markers (fallback)
        "package.json",
        ".git"
    ),

    sources = {
        -- Go format
        null_ls.builtins.formatting.gofmt,

        -- Lua format
        null_ls.builtins.formatting.stylua.with {
            extra_args = {
                "--indent-width",
                "4",
                "--indent-type",
                "Spaces",
            },
        },

        -- Prettier format for HTML, CSS, JS, JSON,...
        null_ls.builtins.formatting.prettier.with {
            extra_args = {
                "--tab-width",
                "4",
                "--use-tabs",
                "false",
                "--trailing-comma",
                "none",
            },
            filetypes = {
                "html",
                "json",
                "jsonc",
                "markdown",
                "css",
                "scss",
                "javascript",
                "typescript",
                "vue",
            },
        },

        -- YAML formatting
        null_ls.builtins.formatting.yamlfmt,

        -- Python format
        null_ls.builtins.formatting.black,
        null_ls.builtins.diagnostics.mypy.with {
            extra_args = function()
                -- Try to get VIRTUAL_ENV or CONDA_PREFIX environment variable
                local virtual_env = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX"

                if virtual_env then
                    -- Append the correct path to the Python executable within that environment
                    return { "--python-executable", virtual_env .. "/bin/python" }
                else
                    -- Fallback or use system default if no venv is detected
                    return {}
                end
            end,
        },
        null_ls.builtins.diagnostics.ruff,
    },
    on_attach = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds {
                group = augroup,
                buffer = bufnr,
            }
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format { bufnr = bufnr }
                end,
            })
        end
    end,
}
