return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" }, -- only load when you use these commands
    init = function()
        -- Expose mason-installed tools (lua-language-server, ...) without loading mason itself
        vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    end,
    opts = {
        PATH = "skip",
        ui = { border = "rounded" },
    },
}
