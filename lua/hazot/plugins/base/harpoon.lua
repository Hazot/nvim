return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        -- REQUIRED
        require("harpoon"):setup({
            settings = {
            -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
            save_on_toggle = false,
            -- saves the harpoon file upon every change. disabling is unrecommended.
            sync_on_ui_close = true,
            -- Set marks specific to each git branch inside git repository
            -- Each branch will have it's own set of marked files
            mark_branch = true,
            key = function()
                return vim.loop.cwd()
            end,
        }
        })
    end
}
