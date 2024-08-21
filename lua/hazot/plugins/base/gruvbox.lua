return {
    "sainnhe/gruvbox-material",
    name = "gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
        vim.g.gruvbox_material_background = "dark"
        vim.g.gruvbox_material_diagnostic_line_highlight = 1
        vim.g.gruvbox_material_diagnostic_text_highlight = 1
        vim.g.gruvbox_material_diagnostic_virtual_text = "highlighted"
        vim.g.gruvbox_material_enable_bold = 1
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_foreground = "mix"
        vim.g.gruvbox_material_inlay_hints_background = "dimmed"
        vim.g.gruvbox_material_transparent_background = 0
        vim.g.gruvbox_material_ui_contrast = "high"
    end,
}
