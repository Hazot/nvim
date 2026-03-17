return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" }, -- only load when you use these commands
    opts = {
        PATH = "prepend", -- prepend Mason bins to PATH
        ui = { border = "rounded" },
    },
}
