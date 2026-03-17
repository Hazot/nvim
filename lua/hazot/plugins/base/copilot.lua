return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        should_attach = function(bufnr, bufname)
            local bt = vim.bo[bufnr].buftype
            if bt ~= "" then
                return false
            end

            if bufname ~= nil and bufname ~= "" then
                return true
            end

            return vim.bo[bufnr].buflisted
        end,
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
