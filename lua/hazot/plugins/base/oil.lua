return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                columns = { "icon" },
                keymaps = {
                    ["<leader>o"] = false,
                },
            })

            -- Open parent directory in current window
            vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>")

            -- Open parent directory in floating window
            vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
        end,
    },
}
