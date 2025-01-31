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
            enabled = false,
            auto_trigger = true, -- Can also do "space"
            debounce = 75, -- Adjust debounce timing
            auto_accept = false, -- Prevents auto-accepting
            inline_suggestion_length = 100, -- Increase to show more text
        },
    },
}
