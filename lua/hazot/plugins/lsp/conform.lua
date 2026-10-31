return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    -- No format-on-save: format only on demand
    keys = {
        {
            "<leader>ff",
            function() require("conform").format({ lsp_format = "fallback", async = true, timeout_ms = 2000 }) end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
        {
            "<A-F>",
            function() require("conform").format({ lsp_format = "fallback", async = true, timeout_ms = 2000 }) end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
    },
    config = function()
        local ruff = require("hazot.util").ruff_bin()

        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff_organize_imports", "ruff_format" },
                lua = { "stylua" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                toml = { "pyproject-fmt" },
                markdown = { "mdformat" },
                -- oxfmt (oxc/VoidZero): Prettier-compatible, ~30x faster.
                -- Zero-config; drop a .oxfmtrc.json per-project to override.
                -- Install: brew install oxfmt (not cargo-installable).
                json = { "oxfmt" },
                jsonc = { "oxfmt" },
                yaml = { "oxfmt" },
                html = { "oxfmt" },
                css = { "oxfmt" },
                scss = { "oxfmt" },
                less = { "oxfmt" },
                javascript = { "oxfmt" },
                javascriptreact = { "oxfmt" },
                typescript = { "oxfmt" },
                typescriptreact = { "oxfmt" },
            },
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                clang_format = {
                    prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}" },
                },
                ruff_format = { command = ruff },
                ruff_organize_imports = { command = ruff },
            },
        })
    end,
}
