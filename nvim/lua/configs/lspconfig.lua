-- Import NvChad defaults
local nv_default = require "nvchad.configs.lspconfig"
local on_attach = nv_default.on_attach
local capabilities = nv_default.capabilities

-- Helper for root detection (new API)
local root_files = {
    gopls = { "go.work", "go.mod" },
    pyright = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".venv" },
}

local function root_dir(files)
    return vim.fs.root(0, files)
end

-----------------------------------------------------------
-- GO (gopls)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "gomod", "gowork", "gotmpl" },
    callback = function()
        vim.lsp.start {
            name = "gopls",
            cmd = { "gopls" },
            root_dir = root_dir(root_files.gopls),
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                gopls = {
                    completeUnimported = true,
                    analyses = { unusedparams = true },
                },
            },
        }
    end,
})

-----------------------------------------------------------
-- PYTHON (pyright)
-----------------------------------------------------------
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "python",
--     callback = function()
--         vim.lsp.start {
--             name = "pyright",
--             cmd = { "pyright-langserver", "--stdio" },
--             root_dir = root_dir(root_files.pyright),
--             on_attach = on_attach,
--             capabilities = capabilities,
--             settings = {
--                 python = {
--                     venvPath = ".",
--                     venv = ".venv",
--                     analysis = {
--                         typeCheckingMode = "basic",
--                         autoSearchPaths = true,
--                         useLibraryCodeForTypes = true,
--                     },
--                 },
--             },
--         }
--     end,
-- })
-- Prioritized root detection - check specific markers first
local function python_root_dir()
    -- Try project-specific markers first (highest priority)
    local root = vim.fs.root(0, { "pyproject.toml", "setup.py", "pyrightconfig.json" })
    if root then
        return root
    end

    -- Then try common markers
    root = vim.fs.root(0, { "requirements.txt", "setup.cfg" })
    if root then
        return root
    end

    -- Finally try .venv (but this might match parent dirs)
    return vim.fs.root(0, { ".venv" })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        local detected_root = python_root_dir()

        -- Build absolute venv path
        local venv_path = detected_root and (detected_root .. "/.venv/bin/python") or nil

        -- Debug output
        -- print("Pyright root_dir: " .. (detected_root or "nil"))
        -- print("Python path: " .. (venv_path or "nil"))

        vim.lsp.start {
            name = "pyright",
            cmd = { "pyright-langserver", "--stdio" },
            root_dir = detected_root,
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                python = {
                    pythonPath = venv_path,
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        extraPaths = detected_root and { detected_root .. "/.venv/lib/python*/site-packages" } or {},
                    },
                },
            },
        }
    end,
})
-----------------------------------------------------------
-- DOCKER COMPOSE (yaml-lsp replacement)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "yml" },
    callback = function()
        vim.lsp.start {
            name = "docker-compose-ls",
            cmd = { "docker-compose-langserver", "--stdio" },
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end,
})
