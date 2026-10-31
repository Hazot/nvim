return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = "nvim-lua/plenary.nvim",
    -- <leader>m for "mark": <leader>a* belongs to claudecode
    keys = {
        { "<leader>m", function() require("harpoon"):list():add() end, desc = "Harpoon add" },
        {
            "<C-e>",
            function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
            desc = "Harpoon menu",
        },
        { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
        { "<C-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
        { "<C-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
        { "<C-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
        { "<C-S-P>", function() require("harpoon"):list():prev() end, desc = "Harpoon prev file" },
        { "<C-S-N>", function() require("harpoon"):list():next() end, desc = "Harpoon next file" },
    },
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
                    return vim.uv.cwd()
                end,
            },
        })
    end,
}
