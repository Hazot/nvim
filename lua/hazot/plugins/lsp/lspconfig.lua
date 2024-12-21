return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
    },
    config = function()
        require("hazot.plugins.lsp.mason")
        -- Install LSP servers automagically
        require("mason-lspconfig").setup({
            ensure_installed = {
                "rust_analyzer",
                "basedpyright",
                "lua_ls",
                "jdtls",
                "clangd",
            },
            automatic_installation = true,
        })

        -- LSP configuration
        local lspconfig = require("lspconfig")

        -- Capabilities
        -- local lsp_defaults = lspconfig.util.default_config
        -- lsp_defaults.capabilities =
        --     vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        -- capabilities.textDocument.foldingRange = {
        --     dynamicRegistration = false,
        --     lineFoldingOnly = true,
        -- }

        -- Keybinds
        function lsp_keymaps(_, bufnr)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end

            -- Omni completion
            -- map("<C-x><C-o>", vim.lsp.omnifunc, "Omni Completion")
            -- Show documentation for what is under cursor
            map("K", vim.lsp.buf.hover, "Hover Documentation")
            -- Jump to the definition of the word under your cursor.
            map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
            -- This is not Goto Definition, this is Goto Declaration.
            map("gD", vim.lsp.buf.declaration, "Goto Declaration")
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
            -- Execute a code action, usually your cursor needs to be on top of an error or a suggestion to activate
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
            -- Mapping to restart lsp if necessary
            map("<leader>rs", ":LspRestart<CR>", "Restart")
            -- Jump to previous diagnostic in buffer
            map("[d", vim.diagnostic.goto_prev, "Goto previous diagnostic")
            -- Jump to next diagnostic in buffer
            map("]d", vim.diagnostic.goto_next, "Goto next diagnostic")
        end

        local on_attach = function(client, bufnr)
            lsp_keymaps(client, bufnr)
        end

        -- Language servers
        local servers = {
            "jdtls",
            "rust_analyzer",
        }

        for _, lsp in pairs(servers) do
            lspconfig[lsp].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                flags = {
                    debounce_text_changes = 150,
                },
            })
        end

        -- Custom LSP servers
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
            on_attach = on_attach,
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
            on_attach = on_attach,
        })

        -- clangd
        lspconfig.clangd.setup({
            cmd = {
                "clangd",
                "--fallback-style=Google",
                "--offset-encoding=utf-16",
            },
            capabilities = capabilities,
            on_attach = on_attach,
        })

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
                spacing = 4, -- Adjust spacing between the virtual text and the line
                severity = { min = vim.diagnostic.severity.INFO }, -- Show all severity levels
                source = "always", -- Show source in virtual text
                prefix = "●", -- Customize the prefix for virtual text
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
