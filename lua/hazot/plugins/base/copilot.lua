return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        panel = {
            enabled = false,
            auto_refresh = true,
        },
        suggestion = {
            enabled = true,
            auto_trigger = true, -- Can also do "space"
            debounce = 75, -- Adjust debounce timing
            auto_accept = false, -- Prevents auto-accepting
            inline_suggestion_length = 100, -- Increase to show more text
            keymap = {
                accept = "<M-l>", -- Alt+l: accept the whole ghost-text suggestion
                accept_word = "<M-w>", -- Alt+w: accept next word
                accept_line = "<M-j>", -- Alt+j: accept next line
                next = "<M-]>", -- Alt+]: cycle to next suggestion
                prev = "<M-[>", -- Alt+[: cycle to previous suggestion
                dismiss = "<C-]>", -- Ctrl+]: dismiss the suggestion
            },
        },
        server_opts_overrides = {
            settings = {
                telemetry = {
                    telemetryLevel = "off",
                },
            },
        },
    },
}
