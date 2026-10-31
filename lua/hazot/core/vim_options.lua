-- Disable unused optional providers (removes the :checkhealth vim.provider warnings).
-- These are only needed by legacy remote plugins, none of which are installed.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Mouse
vim.opt.mouse = "a"

-- Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪"

-- Swap and undo (undo files live in stdpath("state")/undo)
vim.opt.swapfile = false
vim.opt.undofile = true

-- Search (case-insensitive unless the pattern has a capital)
vim.opt.hlsearch = false
vim.opt.ignorecase = true
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
vim.opt.updatetime = 250

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable incrementing hex numbers and letters
vim.opt.nrformats = { "hex", "alpha" }

-- `nvim some/dir` makes that dir the working directory (like `code some/dir`), so pickers stay inside it.
-- The dir is read now because oil renames the buffer to `oil://...` before VimEnter.
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
    local dir = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            vim.cmd.cd(vim.fn.fnameescape(dir))
        end,
    })
end
