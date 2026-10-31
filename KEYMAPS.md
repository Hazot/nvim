# Keymaps cheat sheet

`<leader>` is **Space**. Search every active keymap (with its description) with `<leader>fk`.

Where custom maps are defined:

- `lua/hazot/core/remaps_vim.lua`: general editing (no plugin needed)
- In each plugin's own file (`keys = { ... }` or `on_attach`): Oil, Harpoon, Copilot, snacks pickers, gitsigns, conform, claudecode, blink, LSP

## Files and search

| Keys | Action |
| --- | --- |
| `<leader>pf` | Find files |
| `<C-p>` | Git files (all files outside a repo) |
| `<leader>ps` | Grep text in files |
| `<leader>fb` | Open buffers |
| `<leader>fh` | Help tags |
| `<leader>fk` | Search keymaps |
| `<leader>o` / `<leader>pv` | Oil: file explorer (edit the folder like text, `:w` to apply) |
| `<leader>-` | Oil in a float |

Inside a picker: `<C-j>` / `<C-k>` move, `<CR>` opens, `<Esc>` closes, `<A-h>` toggles hidden files, `<A-i>` toggles ignored files.

## Harpoon (pinned files)

| Keys | Action |
| --- | --- |
| `<leader>m` | Pin current file |
| `<C-e>` | Pinned files menu |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Go to pinned file 1 / 2 / 3 / 4 |
| `<C-S-p>` / `<C-S-n>` | Previous / next pinned file |

## Editing

| Keys | Action |
| --- | --- |
| `<C-/>` or `gcc` | Toggle comment (line) |
| `gc` + motion, or `<C-/>` in visual | Toggle comment (selection / motion, e.g. `gcip`) |
| `J` / `K` in visual | Move selection down / up |
| `<leader>s` | Replace word under cursor in the whole file |
| `<leader>y` / `<leader>Y` | Yank to system clipboard (selection / line) |
| `<leader>p` in visual | Paste over selection without losing the register |
| `<leader>D` | Delete without yank |
| `<leader>ff` or `<A-F>` | Format file (conform) |
| `ys` / `cs` / `ds` | Add / change / delete surroundings (`ysiw"`, `cs"'`, `ds(`) |
| `=` + motion | Re-indent (`==` line, `gg=G` whole file) |

## Completion (insert mode)

| Keys | Action |
| --- | --- |
| `<Tab>` | Accept menu item, else Copilot suggestion, else next snippet field, else tab |
| `<CR>` | Accept menu item |
| `<C-Space>` / `<C-e>` | Open / close the menu |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-]>` | Dismiss Copilot suggestion |
| `<M-w>` / `<M-j>` | Accept Copilot word / line |
| `<M-]>` / `<M-[>` | Next / previous Copilot suggestion |
| `<leader>ce` / `<leader>cd` | Copilot enable / disable (normal mode) |

## LSP (built-in Neovim defaults, plus `gd` / `gD`)

| Keys | Action |
| --- | --- |
| `K` | Hover documentation |
| `gd` / `gD` | Go to definition / declaration |
| `grr` | References |
| `gri` | Implementation |
| `grt` | Type definition |
| `grn` | Rename |
| `gra` | Code action (quick fixes) |
| `gO` | Document symbols |
| `<C-s>` in insert | Signature help |
| `<leader>rs` | Restart LSP |

## Diagnostics (errors and warnings)

| Keys | Action |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic (opens the full message) |
| `]D` / `[D` | Last / first diagnostic |
| `<C-w>d` | Show full message under cursor (press again to enter the float) |

## Git (gitsigns)

| Keys | Action |
| --- | --- |
| `]h` / `[h` | Next / previous hunk (staged ones included) |
| `<leader>hp` | Preview hunk in a float |
| `<leader>hi` | Preview hunk inline |
| `<leader>hd` | Side-by-side diff of the file |
| `<leader>hb` | Blame line |
| `gh` | Toggle changed-line highlights |
| `<leader>hs` | Stage / unstage hunk (selected lines in visual) |
| `<leader>hr` | Reset hunk: discards changes (selected lines in visual) |
| `<leader>hS` / `<leader>hR` | Stage / reset whole file |
| `<leader>hU` | Unstage whole file (keeps changes) |
| `<leader>gs` | Changed files picker (with diff preview) |
| `<leader>gc` / `<leader>gfc` | Commits / commits of this file |
| `<leader>gb` | Branches |
| `:DiffviewOpen` | Review of all changes (`:DiffviewClose`) |

## Claude Code

| Keys | Action |
| --- | --- |
| `<leader>ac` | Toggle Claude Code |
| `<leader>af` | Focus Claude window |
| `<leader>am` | Select model |
| `<leader>aa` | Add current file to context |
| `<leader>as` in visual | Send selection |
| `<leader>ay` / `<leader>an` | Accept / reject proposed diff |

In the Claude terminal: **Esc twice** to leave typing mode, then `<C-w>` + direction to change window; `i` to type again.

## Windows

| Keys | Action |
| --- | --- |
| `<C-w>v` / `<C-w>s` | Split side by side / one above the other |
| `<C-w>h` / `j` / `k` / `l` | Go to the window left / below / above / right |
| `<C-w>w` / `<C-w>p` | Next window / previous window |
| `<C-w>q` / `<C-w>o` | Close window / close all others |
| `<C-w>=` | Equal sizes |
| `<C-w>>` / `<C-w><` / `<C-w>+` / `<C-w>-` | Wider / narrower / taller / shorter |

## Vim motions worth knowing

| Keys | Action |
| --- | --- |
| `-` / `+` (or Enter) | First non-blank of the line above / below |
| `_` or `^` / `0` / `$` | First non-blank / start / end of line |
| `w` / `b` / `e` | Next word / previous word / end of word |
| `f{char}` / `t{char}` | Jump to / before char on the line (`;` repeats, `,` reverses) |
| `%` | Matching bracket |
| `gg` / `G` | Top / bottom of file |
| `<C-d>` / `<C-u>` | Half page down / up (centered) |
| `<C-o>` / `<C-i>` | Jump back / forward |
| `*` / `#` | Search word under cursor forward / backward |
| `ciw` / `ci"` / `cip` | Change inner word / inside quotes / paragraph (`d`, `y`, `v` work the same) |
| `.` | Repeat last change |
| `u` / `<C-r>` | Undo / redo |
