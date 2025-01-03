return {
    "navarasu/onedark.nvim",
    name = "onedark",
    lazy = false,
    priority = 1000, -- Ensure it loads first
    init = function()
        vim.g.onedark_style = "deep"
        vim.g.onedark_transparent_background = true
        vim.g.onedark_terminal_italics = true
        vim.g.onedark_terminal_bold = true
        vim.g.onedark_hide_end_of_buffer = true
    end,
}
