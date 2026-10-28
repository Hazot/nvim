return {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        keymap = {
            -- VS Code-like: <CR> accepts the LSP item, <C-Space> opens the menu, <C-e> closes it
            preset = "enter",
            -- <Tab> (VS Code-like): accepts the menu item when the menu is open, else the Copilot ghost text,
            -- else jumps in a snippet, else inserts a tab
            ["<Tab>"] = {
                "select_and_accept",
                function()
                    local ok, suggestion = pcall(require, "copilot.suggestion")
                    if ok and suggestion.is_visible() then
                        vim.schedule(suggestion.accept)
                        return true
                    end
                end,
                "snippet_forward",
                "fallback",
            },
        },
        completion = {
            documentation = { auto_show = true },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
}
