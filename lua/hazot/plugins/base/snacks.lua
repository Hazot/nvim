return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        picker = {
            enabled = true, -- also routes vim.ui.select (code actions, ...) through the picker
            layout = { preset = "ivy" },
            -- ~ is a dotfiles repo whose .gitignore is `/**`, so .gitignore can't be trusted:
            -- search everything (like `--no-ignore`) and exclude the heavy dirs explicitly
            sources = {
                files = { hidden = true, ignored = true, exclude = { ".git", ".venv", "node_modules" } },
                grep = { hidden = true, ignored = true, exclude = { ".git", ".venv", "node_modules" } },
            },
        },
    },
    keys = {
        { "<leader>pf", function() Snacks.picker.files() end, desc = "Find files" },
        {
            "<C-p>",
            function()
                if vim.fs.root(0, ".git") then
                    Snacks.picker.git_files()
                else
                    Snacks.picker.files()
                end
            end,
            desc = "Git files (fallback: files)",
        },
        { "<leader>ps", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
        { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Search keymaps (cheat sheet: KEYMAPS.md)" },
        { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
        { "<leader>gfc", function() Snacks.picker.git_log_file() end, desc = "Git commits (file)" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
    },
}
