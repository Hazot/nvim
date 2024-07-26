-- Copilot enable/disable
vim.keymap.set("n", "<leader>ce", [[:Copilot enable<CR>]], { noremap = true, silent = true, desc = "Enable Copilot" })
vim.keymap.set("n", "<leader>cd", [[:Copilot disable<CR>]], { noremap = true, silent = true, desc = "Disable Copilot" })

-- Nvim Tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- ToggleTerm
vim.keymap.set({ "n", "v" }, "<leader>tt", "<cmd>ToggleTermToggleAll<cr>", {
    desc = "Toggle terminal",
})
