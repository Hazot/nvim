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
        end,
    },
}
