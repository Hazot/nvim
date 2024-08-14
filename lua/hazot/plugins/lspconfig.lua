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
            },
            automatic_installation = true,
        })

        -- LSP configuration
        local lspconfig = require("lspconfig")

        -- Language servers
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim', 'group' }
                    }
                }
            }
        })

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
        })

        lspconfig.rust_analyzer.setup({})

        lspconfig.clangd.setup({})

        -- Keybinds
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
        vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, {})
        -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
        -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        -- vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next, {})
        -- vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev, {})
    end,
}
