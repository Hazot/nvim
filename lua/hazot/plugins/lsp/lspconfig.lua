return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
    },
    config = function()
        -- Install LSP servers automagically
        require("mason-lspconfig").setup({
            ensure_installed = {
                "rust_analyzer",
                "basedpyright",
                "lua_ls",
                "jdtls",
                "typst_lsp",
                "clangd",
            },
            automatic_installation = true,
        })

        -- LSP configuration
        local lspconfig = require("lspconfig")

        -- Capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        -- Keybinds
        function lsp_keymaps(_, bufnr)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end

            -- Hover
            map("K", vim.lsp.buf.hover, "Hover")
            -- Jump to the definition of the word under your cursor.
            map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")

            -- Find references for the word under your cursor.
            map("gr", require("telescope.builtin").lsp_references, "Goto References")

            -- Jump to the implementation of the word under your cursor.
            map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")

            -- Jump to the type of the word under your cursor.
            map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")

            -- Fuzzy find all the symbols in your current document.
            map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")

            -- Fuzzy find all the symbols in your current workspace.
            map("<leader>ss", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

            -- Rename the variable under your cursor.
            map("<leader>rn", vim.lsp.buf.rename, "Rename")

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

            -- Show documentation for what is under cursor
            map("K", vim.lsp.buf.hover, "Hover Documentation")

            -- This is not Goto Definition, this is Goto Declaration.
            map("gD", vim.lsp.buf.declaration, "Goto Declaration")

            -- Mapping to restart lsp if necessary
            map("<leader>rs", ":LspRestart<CR>", "Restart")

            -- Jump to previous diagnostic in buffer
            map("[d", vim.diagnostic.goto_prev, "Goto previous diagnostic")

            -- Jump to next diagnostic in buffer
            map("]d", vim.diagnostic.goto_next, "Goto next diagnostic")
        end

        local on_attach = function(client, bufnr)
            lsp_keymaps(client, bufnr)
            vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { buffer = bufnr, desc = "Restart" })
        end

        -- Language servers
        -- Basedpyright
        lspconfig.basedpyright.setup({
            cmd = { "basedpyright-langserver", "--stdio" },
            filetypes = { "python" },
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
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
            end,
        })

        -- Lua LSP
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim", "group" },
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
            end,
        })

        -- jdtls
        lspconfig.jdtls.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
            end,
        })

        -- typst_lsp
        lspconfig.typst_lsp.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
            end,
        })

        -- clangd
        lspconfig.clangd.setup({
            cmd = {
                "clangd",
                "--fallback-style=Google",
                "--offset-encoding=utf-16",
            },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
            end,
        })

        -- rust_analyzer
        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
            end,
        })

        -- Keybinds
        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
        -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
        -- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
        -- vim.keymap.set("n", "gI", vim.lsp.buf.implementation, {})
        -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
        -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        -- vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next, {})
        -- vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev, {})

        -- diagnostic
        local signs = {
            Error = " ",
            Warn = " ",
            Hint = "󰌵 ",
            Info = " ",
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, {
                text = icon,
                texthl = hl,
                numhl = "",
            })
        end

        vim.diagnostic.config({
            virtual_text = {
                severity = { min = vim.diagnostic.severity.WARN },
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
