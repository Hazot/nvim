return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
        -- Servers are resolved from $PATH (Homebrew / uv / cargo, or mason's bin dir, see mason.lua).
        -- Built-in 0.11+ maps cover the rest: K, grn, gra, grr, gri, grt, gO, [d, ]d.
        vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("hazot-lsp", { clear = true }),
            callback = function(args)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
                end
                map("gd", vim.lsp.buf.definition, "Goto Definition")
                map("gD", vim.lsp.buf.declaration, "Goto Declaration")
                map("<leader>rs", "<cmd>LspRestart<CR>", "Restart")

                -- ty handles hover for Python
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "ruff" then
                    client.server_capabilities.hoverProvider = false
                end
            end,
        })

        -- ty (Astral): Python type checking. ruff: lint/format.
        vim.lsp.config("ty", {
            settings = {
                ty = {
                    diagnosticMode = "openFilesOnly",
                    inlayHints = { variableTypes = true, callArgumentNames = true },
                    completions = { autoImport = true },
                },
            },
        })

        vim.lsp.config("ruff", {
            root_markers = { "pyproject.toml", "ruff.toml", ".git" },
            cmd = function(dispatchers, config)
                return vim.lsp.rpc.start({ require("hazot.util").ruff_bin(config.root_dir), "server" }, dispatchers)
            end,
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim", "Snacks" } },
                    telemetry = { enable = false },
                },
            },
        })

        vim.lsp.config("clangd", {
            cmd = { "clangd", "--fallback-style=Google", "--offset-encoding=utf-16" },
        })

        vim.lsp.enable({ "ty", "ruff", "lua_ls", "clangd", "rust_analyzer" })

        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,
                severity = { min = vim.diagnostic.severity.INFO },
                source = true,
                prefix = "●",
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = "󰌵 ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            -- ]d / [d open the full message in a float after jumping
            jump = {
                on_jump = function(_, bufnr)
                    vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
                end,
            },
            float = {
                focusable = true, -- <C-w>d twice enters the float (to scroll or yank a long message)
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
    end,
}
