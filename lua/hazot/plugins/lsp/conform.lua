return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
        local conform = require("conform")

        -- Prefer ruff from $PATH, then uv's ~/.local/bin/ruff.
        local function ruff_cmd()
            local from_path = vim.fn.exepath("ruff")
            if from_path ~= "" then
                return from_path
            end

            local home = vim.env.HOME
            local uv_ruff = home and (home .. "/.local/bin/ruff") or nil
            if uv_ruff and vim.fn.executable(uv_ruff) == 1 then
                return uv_ruff
            end

            return "ruff"
        end

        local function format_buffer()
            conform.format({ lsp_fallback = true, async = true, timeout_ms = 2000 })
        end

        conform.setup({
            formatters_by_ft = {
                python = { "isort", "ruff_format" },
                lua = { "stylua" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                -- zsh = { "shfmt" }, -- Not working for zsh
                c = { "clang_format" },
                cpp = { "clang_format" },
                -- java = { "google_java_format" }, -- not downloaded properly it seems
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
            format_on_save = function(bufnr)
                -- Disable autoformat-on-save by default
                vim.b.disable_autoformat = true
                vim.g.disable_autoformat = true

                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end,
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                black = {
                    prepend_args = { "--line-length=120" },
                },
                clang_format = {
                    prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}" },
                },
                ruff_format = {
                    command = ruff_cmd(),
                },
            },
        })

        -- Create commands to enable/disable autoformat-on-save
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })

        -- Keymaps for format (<leader>f is slow since telescope uses <leader>fh and <leader>fb
        vim.keymap.set({ "n", "v" }, "<leader>ff", function()
            format_buffer()
        end, { desc = "Format buffer" })

        vim.keymap.set({ "n", "v" }, "<leader>fd", function()
            format_buffer()
        end, { desc = "Format buffer" })

        vim.keymap.set({ "n", "v" }, "<A-F>", function()
            format_buffer()
        end, { desc = "Format buffer" })

        vim.keymap.set({ "n", "v" }, "<S-A-f>", function()
            format_buffer()
        end, { desc = "Format buffer" })

        if vim.g.neovide or vim.g.vscode then
            vim.keymap.set({ "n", "v" }, "<D-F>", function()
                format_buffer()
            end, { desc = "Format buffer" })
        end

        vim.keymap.set({ "n", "v" }, "<C-I>", function()
            format_buffer()
        end, { desc = "Format buffer" })
    end,
}
