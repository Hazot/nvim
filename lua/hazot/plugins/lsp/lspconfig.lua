return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
    },
    config = function()
        require("hazot.plugins.lsp.mason")

        local util = require("lspconfig.util")
        local uv = vim.uv or vim.loop

        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

        -- utility to find project root
        local function project_root(fname)
            return util.root_pattern("pyproject.toml", "ruff.toml", "pyrightconfig.json", ".git")(fname)
                or util.find_git_ancestor(fname)
                or uv.cwd()
        end

        -- utility to find venv
        local function find_venv(root)
            local cand = {
                vim.env.VIRTUAL_ENV,
                root and (root .. "/.venv") or nil,
                root and (root .. "/.pixi/envs/default") or nil,
            }
            for _, p in ipairs(cand) do
                if p and vim.fn.isdirectory(p) == 1 then
                    return p
                end
            end
            return nil
        end

        --utility to find python executable
        local function venv_python(root)
            local venv = find_venv(root)
            if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
                return venv .. "/bin/python", venv
            end
            return "python3", nil
        end

        local function lsp_keymaps(_, bufnr)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end
            map("K", vim.lsp.buf.hover, "Hover Documentation")
            map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
            map("gD", vim.lsp.buf.declaration, "Goto Declaration")
            map("gr", require("telescope.builtin").lsp_references, "Goto References")
            map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
            map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
            map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
            map("<leader>ss", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
            map("<leader>rn", vim.lsp.buf.rename, "Rename")
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
            map("<leader>rs", ":LspRestart<CR>", "Restart")
            map("[d", vim.diagnostic.goto_prev, "Goto previous diagnostic")
            map("]d", vim.diagnostic.goto_next, "Goto next diagnostic")
        end

        local on_attach = function(client, bufnr)
            lsp_keymaps(client, bufnr)
        end

        -- Use vim.lsp.config() for Neovim 0.11+
        -- basedpyright
        vim.lsp.config("basedpyright", {
            filetypes = { "python" },
            root_markers = { "pyproject.toml", "ruff.toml", "pyrightconfig.json", ".git" },
            on_new_config = function(new_config, root)
                local py, venv = venv_python(root)
                new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, {
                    python = {
                        pythonPath = py,
                        venvPath = venv and vim.fn.fnamemodify(venv, ":h") or nil,
                        venv = venv and vim.fn.fnamemodify(venv, ":t") or nil,
                        analysis = { autoImportCompletions = true },
                    },
                })
            end,
            settings = {
                basedpyright = {
                    disableOrganizeImports = true,
                    typeCheckingMode = "standard",
                    analysis = {
                        inlayHints = {
                            callArgumentNames = "all",
                            functionReturnTypes = true,
                            pytestParameters = true,
                            variableTypes = true,
                        },
                        autoFormatStrings = true,
                    },
                    linting = { enabled = true },
                },
            },
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- Ruff
        vim.lsp.config("ruff", {
            root_markers = { "pyproject.toml", "ruff.toml", ".git" },
            on_new_config = function(new_config, root)
                local _, venv = venv_python(root)
                if venv and vim.fn.executable(venv .. "$HOME/.local/bin/ruff") == 1 then
                    new_config.cmd = { venv .. "$HOME/.local/bin/ruff", "server" }
                end
            end,
            settings = {
                ruff = { args = { "--config", "/dev/null" } },
            },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                client.server_capabilities.hoverProvider = false
            end,
        })

        -- lua_ls
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim", "group" } },
                    telemetry = { enable = false },
                },
            },
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- clangd
        vim.lsp.config("clangd", {
            cmd = { "clangd", "--fallback-style=Google", "--offset-encoding=utf-16" },
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- jdtls
        vim.lsp.config("jdtls", {
            capabilities = capabilities,
            on_attach = on_attach,
            flags = { debounce_text_changes = 150 },
        })

        -- rust_analyzer
        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
            on_attach = on_attach,
            flags = { debounce_text_changes = 150 },
        })

        -- Enable the servers
        vim.lsp.enable("basedpyright")
        vim.lsp.enable("ruff")
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("clangd")
        vim.lsp.enable("jdtls")
        vim.lsp.enable("rust_analyzer")

        local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
        for type, icon in pairs(signs) do
            vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
        end
        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,
                severity = { min = vim.diagnostic.severity.INFO },
                source = "always",
                prefix = "●",
            },
            signs = true,
            update_in_insert = true,
            underline = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
    end,
}
