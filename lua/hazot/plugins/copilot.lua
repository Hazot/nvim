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
        },
    },
}
