return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "rshkarin/mason-nvim-lint", dependencies = "williamboman/mason.nvim" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            c = { "trivy" },
            cpp = { "trivy" },
            rust = { "trivy" },
            python = { "trivy" },
            java = { "trivy" },
            javascript = { "trivy" },
            typescript = { "trivy" },
        }

        -- Install linters with mason
        require("mason-nvim-lint").setup()

        -- Lint on entering buffer, saving and leaging insert mode
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
            group = vim.api.nvim_create_augroup("plugin-lint", { clear = true }),
            desc = "Lint on entering buffer, saving and leaging insert mode",
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Lint buffer" })
    end,
}
