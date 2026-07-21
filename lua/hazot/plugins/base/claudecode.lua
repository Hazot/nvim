return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" }, -- terminal UI (pulled in automatically)
    config = true, -- use default opts; `claude` is found on $PATH via nvm
    -- Lazy-load on the commands and keymaps below
    cmd = {
        "ClaudeCode",
        "ClaudeCodeFocus",
        "ClaudeCodeSelectModel",
        "ClaudeCodeSend",
        "ClaudeCodeAdd",
        "ClaudeCodeTreeAdd",
        "ClaudeCodeStatus",
        "ClaudeCodeStart",
        "ClaudeCodeStop",
        "ClaudeCodeOpen",
        "ClaudeCodeClose",
        "ClaudeCodeDiffAccept",
        "ClaudeCodeDiffDeny",
    },
    keys = {
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code: toggle" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code: focus" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude Code: select model" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude Code: send selection" },
        { "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude Code: add current file" },
        -- Accept / deny a proposed diff
        { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude Code: accept diff" },
        { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude Code: deny diff" },
    },
}
