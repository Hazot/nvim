return {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local telescopeConfig = require("telescope.config")
        local actions = require("telescope.actions")

        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

        -- I want to search in hidden/dot files.
        table.insert(vimgrep_arguments, "--no-ignore")
        table.insert(vimgrep_arguments, "--hidden")
        -- I don't want to search in the `.git` directory.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.git/*")

        telescope.setup({
            defaults = {
                -- `hidden = true` is not supported in text grep commands.
                hidden = true,
                vimgrep_arguments = vimgrep_arguments,
            },
            pickers = {
                find_files = {
                    hidden = true,
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = {
                        "fd",
                        "--no-ignore",
                        "--hidden",
                        "--exclude",
                        ".git",
                    },
                },
            },
        })

        --- This activates the search for hidden files in live_grep
        require("telescope").setup({
            pickers = {
                live_grep = {
                    additional_args = function(_ts)
                        return { "--hidden" }
                    end,
                },
            },
        })

        -- Ui actions
        telescope.setup({
            defaults = require("telescope.themes").get_ivy({
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<esc>"] = actions.close,
                        ["<CR>"] = actions.select_default + actions.center,
                    },
                },
            }),
            pickers = {
                buffers = {
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer,
                        },
                    },
                },
                colorscheme = {
                    enable_preview = true,
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
                ["fzf-native"] = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
            },
            require("telescope").load_extension("fzf"),
            require("telescope").load_extension("ui-select"),
        })

        -- Keybinds
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
        vim.keymap.set("n", "<leader>gfc", builtin.git_bcommits, {})
        vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
        vim.keymap.set("n", "<leader>gb", builtin.git_branches, {})
    end,
}
