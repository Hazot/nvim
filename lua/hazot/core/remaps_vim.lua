-- Vim keybinds/remaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "File explorer (Oil)" })

-- Moves highlighted text together in visual mode with J and K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Does not move mouse when appending lines with J
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (cursor stays)" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Can delete highglight without copying it and then paste the current buffer
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection (keep register)" })

-- Ctrl+/ toggles comments (terminals send <C-_> or <C-/> depending on the keyboard protocol)
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle commenting", remap = true })
vim.keymap.set("n", "<C-/>", "gcc", { desc = "Toggle commenting", remap = true })
vim.keymap.set("x", "<C-_>", "gc", { desc = "Toggle commenting", remap = true })
vim.keymap.set("x", "<C-/>", "gc", { desc = "Toggle commenting", remap = true })

-- Yank multiple lines to clipboard easily
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Delete without yank
vim.keymap.set({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yank" })

-- Only difference between escape and ctrl+c
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- Do not use Q
vim.keymap.set("n", "Q", "<nop>", { desc = "Do not use Q" })

-- Can easily replace all the words in a file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor (whole file)" })

-- Fighting one-eyed kirby
vim.keymap.set(
    "v",
    "<leader>k",
    ":s/\\(\\S.*\\)/ \\1/g<left><left><left><left><left>",
    { desc = "Fighting one-eyed kirby or multi-line leading editor" }
)

-- Have j and k working with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (wrapped lines)" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (wrapped lines)" })

-- Set ctrl+backspace to delete words like C-w
vim.keymap.set("i", "<C-H>", "<C-W>", { desc = "Delete word before cursor (Ctrl+Backspace)" })
