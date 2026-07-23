return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" }, -- BufReadPost avoids running on dirs opened via netrw
    config = function()
        local lint = require("lint")

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

        -- Explicitly set only the linters you want, and disable for md/tex to prevent accidental 'vale'
        lint.linters_by_ft = {
            c = { "clangtidy" }, -- static analysis for C
            cpp = { "clangtidy" }, -- static analysis for C++
            rust = { "clippy" }, -- Rust’s official linter
            python = { "ruff" }, -- fast Python linter (your choice)
            javascript = { "eslint" }, -- JS linter
            typescript = { "eslint" }, -- TS linter (via eslint + typescript plugin)
            markdown = { "markdownlint" }, -- <- make sure vale won't run
            tex = { "chktex" }, -- <- make sure vale won't run
        }

        -- Linters run off $PATH: ruff, markdownlint (Homebrew/npm/pip), plus
        -- eslint (npm), clippy (rustup), clangtidy (clang-tools), chktex (TeXLive).
        -- mason is optional: if mason-nvim-lint happens to be installed, use it to
        -- best-effort auto-install the mason-distributed linters; otherwise skip
        -- silently. Never let a missing/broken mason crash linting.
        pcall(function()
            require("mason-nvim-lint").setup({
                ignore_install = { "eslint", "clippy", "clangtidy", "chktex" },
            })
        end)

        -- Prefer ruff from venv/uv over whatever mason may have installed.
        if lint.linters.ruff then
            lint.linters.ruff.cmd = ruff_cmd()
        end

        -- Guarded lint trigger
        local aug = vim.api.nvim_create_augroup("plugin-lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave", "TextChanged" }, {
            group = aug,
            desc = "Lint on buffer events (guarded, real files only)",
            callback = function()
                -- Skip special buffers (help, quickfix, terminal, netrw, etc.)
                if vim.bo.buftype ~= "" then
                    return
                end
                if vim.bo.filetype == "netrw" then
                    return
                end

                -- Must be a real, readable file (not unnamed/new or directory)
                local path = vim.api.nvim_buf_get_name(0)
                if path == "" or vim.fn.filereadable(path) ~= 1 then
                    return
                end
                if vim.fn.isdirectory(path) == 1 then
                    return
                end

                -- Only run if we actually configured linters for this filetype
                local ft = vim.bo.filetype
                local configured = lint.linters_by_ft and lint.linters_by_ft[ft]
                if not configured or #configured == 0 then
                    return
                end

                lint.try_lint()
            end,
        })
    end,
}
