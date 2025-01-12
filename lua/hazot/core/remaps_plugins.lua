-- Copilot enable/disable
vim.keymap.set("n", "<leader>ce", [[:Copilot enable<CR>]], { desc = "Copilot enable" })
vim.keymap.set("n", "<leader>cd", [[:Copilot disable<CR>]], { desc = "Copilot disable" })

-- Supermaven
vim.keymap.set("n", "<leader>sm", "<cmd>SupermavenToggle<cr>", { desc = "Toggle Supermaven" })

-- Neo Tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {})
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", {})

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Gitgutter
vim.keymap.set("n", "<leader>gg", vim.cmd.GitGutterLineHighlightsToggle)
