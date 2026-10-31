return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false, -- must load at startup to open directories (`nvim some/dir`)
        keys = {
            { "<leader>o", "<cmd>Oil<CR>", desc = "Open Oil parent directory in current window" },
            { "<leader>-", function() require("oil").toggle_float() end, desc = "Open Oil float" },
        },
        config = function()
            require("oil").setup({
                columns = { "icon" },
                keymaps = {
                    ["<leader>o"] = false,
                },
            })
        end,
    },
}
