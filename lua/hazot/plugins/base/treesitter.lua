return {
    "nvim-treesitter/nvim-treesitter",
    -- The `main` branch is the rewrite that targets current/nightly Neovim
    -- (0.11+). It uses Neovim's built-in treesitter for highlight/fold and
    -- provides parser install + experimental indent.
    branch = "main",
    build = ":TSUpdate",
    -- Load before a file is displayed so the FileType autocmd below can start
    -- highlighting on the very first buffer.
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- Parsers to keep installed. install() is async and only fetches the
        -- ones that are missing, so it's cheap to call on every startup.
        local ensure = {
            "bash",
            "python",
            "javascript",
            "markdown",
            "markdown_inline",
            "c",
            "cpp",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "comment",
            "toml",
            "json",
            "yaml",
        }
        require("nvim-treesitter").install(ensure)

        -- Enable treesitter features per buffer. On `main`, highlighting is a
        -- core Neovim feature (vim.treesitter.start) and is not auto-enabled.
        local group = vim.api.nvim_create_augroup("hazot-treesitter", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            callback = function(args)
                local buf = args.buf
                local ft = args.match
                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then
                    return
                end
                -- Highlighting (no-op/erroring safely if the parser isn't installed yet)
                if pcall(vim.treesitter.start, buf, lang) then
                    -- Experimental treesitter indentation
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
