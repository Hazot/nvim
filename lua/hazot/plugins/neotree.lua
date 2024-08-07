return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("neo-tree").setup({
            default_component_configs = {
                filesystem = {
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false,
                    },
                },
            },
            close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
            enable_git_status = true,
        })
    end,
}
