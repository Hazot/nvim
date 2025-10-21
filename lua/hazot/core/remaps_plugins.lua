-- Copilot enable/disable
vim.keymap.set("n", "<leader>ce", [[:Copilot enable<CR>]], { desc = "Copilot enable" })
vim.keymap.set("n", "<leader>cd", [[:Copilot disable<CR>]], { desc = "Copilot disable" })

-- Supermaven
vim.keymap.set("n", "<leader>sm", "<cmd>SupermavenToggle<cr>", { desc = "Toggle Supermaven" })

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Gitgutter
vim.keymap.set("n", "gg", vim.cmd.GitGutterLineHighlightsToggle, { desc = "Toggle GitGutter highlights" })
vim.keymap.set("n", "]h", "<Plug>(GitGutterNextHunk)", { desc = "Next Git hunk" })
vim.keymap.set("n", "[h", "<Plug>(GitGutterPrevHunk)", { desc = "Prev Git hunk" })
