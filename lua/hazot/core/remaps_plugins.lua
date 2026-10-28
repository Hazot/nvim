-- Plugins Keybinds/remaps
-- Copilot enable/disable
vim.keymap.set("n", "<leader>ce", [[:Copilot enable<CR>]], { desc = "Copilot enable" })
vim.keymap.set("n", "<leader>cd", [[:Copilot disable<CR>]], { desc = "Copilot disable" })

-- Oil Open parent directory in current window
vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open Oil parent directory in current window" })
vim.keymap.set("n", "<leader>-", function()
    require("oil").toggle_float()
end, { desc = "Open Oil float" })

-- Harpoon (<leader>m for "mark": <leader>a* belongs to claudecode)
vim.keymap.set("n", "<leader>m", function() require("harpoon"):list():add() end, { desc = "Harpoon add" })
vim.keymap.set("n", "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon menu" })

vim.keymap.set("n", "<C-h>", function() require("harpoon"):list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<C-j>", function() require("harpoon"):list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<C-k>", function() require("harpoon"):list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<C-l>", function() require("harpoon"):list():select(4) end, { desc = "Harpoon file 4" })

-- Toggle previous & next buffers stored within harpoon list
vim.keymap.set("n", "<C-S-P>", function() require("harpoon"):list():prev() end, { desc = "Harpoon prev file" })
vim.keymap.set("n", "<C-S-N>", function() require("harpoon"):list():next() end, { desc = "Harpoon next file" })
