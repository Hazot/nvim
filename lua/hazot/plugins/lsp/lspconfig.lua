return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
    },
    config = function()
        require("hazot.plugins.lsp.mason")

        -- mason-lspconfig: turn off auto-enable (needs nvim 0.11)
        require("mason-lspconfig").setup({
            ensure_installed = {
                "rust_analyzer",
                "basedpyright",
                "lua_ls",
                "jdtls",
                "clangd",
                "ruff",
            },
            automatic_installation = true,
            automatic_enable = false, -- <-- add this line
        })

        local lspconfig = require("lspconfig")
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
            -- priority: explicit env, .venv (uv default), pixi’s default env
            local cand = {
                vim.env.VIRTUAL_ENV,
                root and (root .. "/.venv") or nil, -- uv venv
                root and (root .. "/.pixi/envs/default") or nil, -- pixi default
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

        for _, lsp in ipairs({ "jdtls", "rust_analyzer" }) do
            lspconfig[lsp].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                flags = { debounce_text_changes = 150 },
            })
        end

        -- basedpyright
        lspconfig.basedpyright.setup({
            -- If you installed via Mason, you can omit `cmd` and let lspconfig resolve it.
            -- cmd = { "basedpyright-langserver", "--stdio" },
            filetypes = { "python" },
            root_dir = project_root,
            -- Tell the server where the venv lives
            on_new_config = function(new_config, root)
                local py, venv = venv_python(root)
                new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, {
                    python = {
                        pythonPath = py, -- interpreter for stub resolution
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

        -- Ruff (reads pyproject.toml / ruff.toml from root)
        lspconfig.ruff.setup({
            root_dir = project_root,
            on_new_config = function(new_config, root)
                local _, venv = venv_python(root)
                if venv and vim.fn.executable(venv .. "/bin/ruff") == 1 then
                    new_config.cmd = { venv .. "/bin/ruff", "server" } -- ruff’s LSP mode
                end
            end,
            settings = {
                -- to avoid "No configuration file found" warnings
                -- (ruff will still read pyproject.toml / ruff.toml from root)
                ruff = { args = { "--config", "/dev/null" } },
            },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                client.server_capabilities.hoverProvider = false -- let Pyright/BasedPyright do hovers
            end,
        })

        -- lua_ls
        lspconfig.lua_ls.setup({
            settings = { Lua = { diagnostics = { globals = { "vim", "group" } }, telemetry = { enable = false } } },
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- clangd
        lspconfig.clangd.setup({
            cmd = { "clangd", "--fallback-style=Google", "--offset-encoding=utf-16" },
            capabilities = capabilities,
            on_attach = on_attach,
        })

        local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
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
