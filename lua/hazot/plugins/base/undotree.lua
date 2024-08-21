return {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPre", "bufNewFile" },
    config = true,
}
