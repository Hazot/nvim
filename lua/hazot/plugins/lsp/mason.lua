return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" }, -- only load when you use these commands
    opts = {
        -- Prepend Mason's bin dir to PATH (default) so installed tools
        -- (stylua, shfmt, lua-language-server, ...) are found by conform/lspconfig.
        PATH = "prepend",
        ui = { border = "rounded" },
    },
}
