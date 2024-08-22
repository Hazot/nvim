-- Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Mouse
vim.opt.mouse = "a"

-- Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪"

-- Backup and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hidden = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartcase = true

-- Colors
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Cursor
vim.opt.cursorline = true
vim.opt.colorcolumn = { "80", "120" }

-- Other
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.autoread = true

-- Show list
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", extends = ">", precedes = "<" }
-- vim.opt.listchars = { eol = "¬", tab = ">·", trail = "~", extends = ">", precedes = "<", space = "␣" }

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable incrementing hex numbers and letters
vim.api.nvim_set_option("nrformats", "hex,alpha")

-- Autocmds
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.md", "*.tex" },
    group = group,
    command = "setlocal wrap",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cpp", "h" },
    callback = function()
        -- Can set to 2 here if I want
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
    end,
})
