-- Built-in commands like `zo` aren't mappings, so the keymap picker can't see them.
-- doc/index.txt lists them all, grouped under numbered headings that give their mode.
-- Section 6 (Ex commands) has no entry here: parsing stops at it.
local index_modes = {
    ["1."] = "i",
    ["2."] = "n",
    ["2.1"] = "o",
    ["2.2"] = "n",
    ["2.3"] = "n",
    ["2.4"] = "n",
    ["2.5"] = "n",
    ["2.6"] = "o",
    ["3."] = "x",
    ["4."] = "c",
    ["5."] = "t",
}

local builtin_keys

local function read_builtin_keys()
    if builtin_keys then
        return builtin_keys
    end
    builtin_keys = {}
    local path = vim.env.VIMRUNTIME .. "/doc/index.txt"
    local mode, entry
    local previous = ""
    for lnum, line in ipairs(vim.fn.readfile(path)) do
        local section = previous:match("^=+$") and line:match("^(%d%.%d?)%s")
        if section then
            mode = index_modes[section]
            if not mode then
                break
            end
        elseif mode then
            local tag, rest = line:match("^|(.-)|%s+(.*)$")
            if tag then
                -- Columns are usually tab-separated, but long keys run into the description
                local keys, desc = rest:match("^(.-)\t+(.*)$")
                if not keys then
                    keys, desc = rest:match("^(.-)%s%s+(.*)$")
                end
                if not keys then
                    keys, desc = rest:match("^(.-}) ([^{].*)$")
                end
                keys, desc = keys or rest, desc or ""
                local lhs = keys:gsub('^%["x%]', "")
                    :gsub("CTRL%-SHIFT%-(.)", "<C-S-%1>")
                    :gsub("CTRL%-<(.-)>", "<C-%1>")
                    :gsub("CTRL%-(.)", "<C-%1>")
                    :gsub(" ", "")
                entry = { tag = tag, mode = mode, lhs = lhs, desc = vim.trim(desc:gsub("^[12]%s+", "")), lnum = lnum }
                table.insert(builtin_keys, entry)
            elseif entry and line:match("^%s+[^\t]+$") then
                entry.desc = vim.trim(entry.desc .. " " .. vim.trim(line))
            else
                entry = nil
            end
        end
        previous = line
    end
    builtin_keys.path = path
    local help_files = {}
    for _, line in ipairs(vim.fn.readfile(vim.env.VIMRUNTIME .. "/doc/tags")) do
        local tag, file = line:match("^([^\t]+)\t([^\t]+)")
        if tag then
            help_files[tag] = file
        end
    end
    for _, key in ipairs(builtin_keys) do
        key.help_file = help_files[key.tag]
    end
    return builtin_keys
end

local function keymaps_with_builtins(opts, ctx)
    local items = require("snacks.picker.source.vim").keymaps(opts, ctx)
    local builtins = read_builtin_keys()
    for _, key in ipairs(builtins) do
        local remapped = vim.fn.maparg(key.lhs, key.mode, false, true).lhs ~= nil
        local desc = (remapped and "[builtin, remapped] " or "[builtin] ") .. key.desc
        table.insert(items, {
            text = table.concat({ key.lhs, key.mode, desc }, " "),
            mode = key.mode,
            key = key.lhs,
            builtin_tag = key.tag,
            help_file = key.help_file,
            item = { mode = key.mode, lhs = key.lhs, desc = desc },
            file = builtins.path,
            pos = { key.lnum, 0 },
            preview = "file",
        })
    end
    return items
end

-- Same data as the default keymap format, with the description right after the key
local function format_keymap(item, picker)
    local keymap = item.item
    local align = Snacks.picker.util.align
    local ret = {
        { keymap.mode, "SnacksPickerKeymapMode" },
        { " " },
        { align(Snacks.util.normkey(keymap.lhs), 12), "SnacksPickerKeymapLhs" },
        { " " },
        { align(keymap.desc or "", 50) },
    }
    if item.builtin_tag then
        return ret
    end
    table.insert(ret, { " " })
    if keymap.buffer and keymap.buffer > 0 then
        table.insert(ret, { "buf:" .. keymap.buffer .. " ", "SnacksPickerBufNr" })
    end
    if keymap.rhs and keymap.rhs ~= "" then
        table.insert(ret, { keymap.rhs, "SnacksPickerKeymapRhs" })
    else
        table.insert(ret, { "callback", "Function" })
    end
    if item.file then
        table.insert(ret, { " " })
        vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
    end
    return ret
end

local function confirm_keymap(picker, item)
    if item and item.builtin_tag then
        picker:close()
        -- :help rewrites its argument, which breaks tags like `^` or `CTRL-<Tab>`: jump to the tag by hand
        vim.cmd.help(item.help_file or "index.txt")
        vim.api.nvim_win_set_cursor(0, item.help_file and { 1, 0 } or item.pos)
        if item.help_file then
            vim.fn.search("\\C\\V*" .. vim.fn.escape(item.builtin_tag, "\\") .. "*", "c")
        end
    else
        require("snacks.picker.config.sources").keymaps.confirm(picker, item)
    end
end

return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        picker = {
            enabled = true, -- also routes vim.ui.select (code actions, ...) through the picker
            layout = { preset = "ivy" },
            -- ~ is a dotfiles repo whose .gitignore is `/**`, so .gitignore can't be trusted:
            -- search everything (like `--no-ignore`) and exclude the heavy dirs explicitly
            sources = {
                files = { hidden = true, ignored = true, exclude = { ".git", ".venv", "node_modules" } },
                grep = { hidden = true, ignored = true, exclude = { ".git", ".venv", "node_modules" } },
            },
        },
    },
    keys = {
        { "<leader>pf", function() Snacks.picker.files() end, desc = "Find files" },
        {
            "<C-p>",
            function()
                if vim.fs.root(0, ".git") then
                    Snacks.picker.git_files()
                else
                    Snacks.picker.files()
                end
            end,
            desc = "Git files (fallback: files)",
        },
        { "<leader>ps", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
        {
            "<leader>fk",
            function()
                Snacks.picker.keymaps({
                    finder = keymaps_with_builtins,
                    format = format_keymap,
                    confirm = confirm_keymap,
                })
            end,
            desc = "Search keymaps and Vim built-ins (cheat sheet: KEYMAPS.md)",
        },
        { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
        { "<leader>gfc", function() Snacks.picker.git_log_file() end, desc = "Git commits (file)" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
    },
}
