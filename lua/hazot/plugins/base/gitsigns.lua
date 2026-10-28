return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gs = require("gitsigns")
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end
            local range = function()
                return { vim.fn.line("."), vim.fn.line("v") }
            end

            -- Navigation (staged hunks included, so they can be unstaged)
            map("n", "]h", function() gs.nav_hunk("next", { target = "all" }) end, "Next hunk")
            map("n", "[h", function() gs.nav_hunk("prev", { target = "all" }) end, "Prev hunk")

            -- Look at changes
            map("n", "<leader>hp", gs.preview_hunk, "Preview hunk (float)")
            map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk (inline)")
            map("n", "<leader>hd", gs.diffthis, "Diff file against index (side by side)")
            map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
            map("n", "gh", gs.toggle_linehl, "Toggle hunk line highlights")

            -- Stage / reset (in visual mode: only the selected lines)
            map("n", "<leader>hs", gs.stage_hunk, "Stage hunk (toggle)")
            map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
            map("v", "<leader>hs", function() gs.stage_hunk(range()) end, "Stage selected lines")
            map("v", "<leader>hr", function() gs.reset_hunk(range()) end, "Reset selected lines")
            map("n", "<leader>hS", gs.stage_buffer, "Stage file")
            map("n", "<leader>hR", gs.reset_buffer, "Reset file")
            map("n", "<leader>hU", gs.reset_buffer_index, "Unstage file (keeps changes)")
        end,
    },
}
