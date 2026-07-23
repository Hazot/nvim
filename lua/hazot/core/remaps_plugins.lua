-- Copilot enable/disable
vim.keymap.set("n", "<leader>ce", [[:Copilot enable<CR>]], { desc = "Copilot enable" })
vim.keymap.set("n", "<leader>cd", [[:Copilot disable<CR>]], { desc = "Copilot disable" })

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Gitgutter
vim.keymap.set("n", "gh", vim.cmd.GitGutterLineHighlightsToggle, { desc = "Toggle GitGutter highlights" })
vim.keymap.set("n", "]h", "<Plug>(GitGutterNextHunk)", { desc = "Next Git hunk" })
vim.keymap.set("n", "[h", "<Plug>(GitGutterPrevHunk)", { desc = "Prev Git hunk" })

-- Oil Open parent directory in current window
vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>",
{ desc = "Open Oil parent directory in current window" })
vim.keymap.set("n", "<leader>-", function()
    require("oil").toggle_float()
end, { desc = "Open Oil float" })

-- Linting
vim.keymap.set("n", "<leader>l", function()
    require("lint").try_lint()
end, { desc = "Lint buffer" })

-- Harpoon
vim.keymap.set("n", "<leader>a", function() require("harpoon"):list():add() end)
vim.keymap.set("n", "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end)

vim.keymap.set("n", "<C-h>", function() require("harpoon"):list():select(1) end)
vim.keymap.set("n", "<C-j>", function() require("harpoon"):list():select(2) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon"):list():select(3) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon"):list():select(4) end)

-- Toggle previous & next buffers stored within harpoon list
vim.keymap.set("n", "<C-S-P>", function() require("harpoon"):list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() require("harpoon"):list():next() end)
