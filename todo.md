# TODO nvim

Paths are relative to `lua/hazot/`.

## 1. Bugs

- [ ] **`:FormatEnable` never works** (`plugins/lsp/conform.lua:55`). `format_on_save` sets `disable_autoformat = true` every time it runs.
      **Fix:** set the default once before `setup()`, and keep the callback read-only:

  ```lua
  vim.g.disable_autoformat = true -- off by default
  format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
      return { timeout_ms = 500, lsp_format = "fallback" }
  end,
  ```

- [ ] **The venv ruff lookup never runs** (`plugins/lsp/lspconfig.lua:125`). `on_new_config` is part of the old lspconfig API, and `vim.lsp.config()` ignores it.
      **Fix (0.12+, `cmd` can be a function that gets the config):**

  ```lua
  cmd = function(dispatchers, config)
      return vim.lsp.rpc.start({ ruff_bin(config.root_dir), "server" }, dispatchers)
  end,
  ```

  Simpler alternative: `cmd = { ruff_bin(), "server" }`, resolved once at startup (PATH, then `~/.local/bin`), and drop the venv lookup.

- [ ] **Tab/S-Tab in cmp take the wrong branch** (`plugins/lsp/cmp.lua:111,125`). `not cmp.visible` is missing its `()`, so it is always false.
      **Fix:** `not cmp.visible()` in both places.

- [ ] **`group = group` points to an undefined global** (`core/vim_options.lua:71`). `"group"` was added to the lua_ls globals and to `.luarc.json` only to hide the warning.
      **Fix:** delete that autocmd (see section 4, it does nothing), then remove `"group"` from `lspconfig.lua:143` and `.luarc.json`.

- [ ] **`<C-I>` = `<Tab>`** (`plugins/lsp/conform.lua:124`). Mapping it to format breaks `<C-o>`/`<C-i>` in the jumplist.
      **Fix:** delete that mapping; `<leader>ff` and `<A-F>` are enough.

- [ ] **telescope `setup()` is called 3 times** (`plugins/base/telescope.lua`). Later calls can overwrite `defaults`/`pickers`. `load_extension()` is called inside the options table, and the extension key is `"fzf-native"` when it should be `"fzf"`.
      **Fix:** a single call:

  ```lua
  telescope.setup({
      defaults = require("telescope.themes").get_ivy({
          vimgrep_arguments = vimgrep_arguments,
          path_display = { "truncate" },
          mappings = { i = { ... } },
      }),
      pickers = {
          find_files = { hidden = true, find_command = { "fd", "--hidden", "--exclude", ".git" } },
          live_grep = { additional_args = { "--hidden" } },
          buffers = { mappings = { i = { ["<c-d>"] = actions.delete_buffer } } },
          colorscheme = { enable_preview = true },
      },
      extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
          fzf = { override_generic_sorter = true, override_file_sorter = true },
      },
  })
  telescope.load_extension("ui-select")
  telescope.load_extension("fzf")
  ```

- [ ] **cmp sources declared without their plugin installed**: `lazydev`, `pandoc_references`, `crates` (`plugins/lsp/cmp.lua:41,45,161`).
      **Fix:** add lazydev (better Lua completion, and it replaces `cmp-nvim-lua`), and remove `pandoc_references` and the Cargo.toml autocmd (or install `saecki/crates.nvim`):
  ```lua
  -- plugins/lsp/lazydev.lua
  return {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
  }
  ```

## 2. Keymap conflicts

- [ ] **`<leader>a` (harpoon add) is also the prefix of the `<leader>a*` claudecode maps**, so harpoon waits for `timeoutlen`.
      **Fix:** move harpoon add to `<leader>m` (mark) in `core/remaps_plugins.lua:26`.

- [ ] **`<leader>D`**: delete without yank (global) is shadowed by LSP type definition in LSP buffers.
      **Fix:** move type definition to `gy` (`lspconfig.lua:85`).

- [ ] **`<leader>s` (substitute) and `<leader>ss` (workspace symbols)** cause a delay.
      **Fix:** move workspace symbols to `<leader>ws`.

- [ ] **`gf` (actions-preview) replaces the built-in "go to file"** and does the same job as `<leader>ca`.
      **Fix:** in `lspconfig.lua:89`, `map("<leader>ca", require("actions-preview").code_actions, "Code Action")`, and remove the `gf` map from `actions-preview.lua` (lazy load with `keys`).

- [ ] **Duplicate format maps**: `<leader>ff` = `<leader>fd`, and `<A-F>` = `<S-A-f>`.
      **Fix:** keep `<leader>ff` and `<A-F>`, delete the others.

- [ ] **`<leader>hh` (nohlsearch) does nothing** because `hlsearch = false`.
      **Fix:** delete it. Or turn on `hlsearch = true` and use `vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")`.

- [ ] **`<C-p>` (`git_files`) errors outside a git repo.**
      **Fix:**

  ```lua
  vim.keymap.set("n", "<C-p>", function()
      if vim.fs.root(0, ".git") then builtin.git_files() else builtin.find_files() end
  end, { desc = "Git files (fallback: files)" })
  ```

- [ ] **`<C-_>` in visual mode sends `gcc`** (`core/remaps_vim.lua:20`): `gc` comments the selection, then `c` starts a change.
      **Fix:** map `n` -> `"gcc"` and `v` -> `"gc"` separately.

## 3. Deprecated APIs (Neovim 0.11+)

- [ ] `vim.diagnostic.goto_prev/next` (`lspconfig.lua:91`) -> `function() vim.diagnostic.jump({ count = -1, float = true }) end` (`count = 1` for next).
- [ ] `vim.fn.sign_define("DiagnosticSign...")` (`lspconfig.lua:172`) -> inside `vim.diagnostic.config`:
  ```lua
  signs = { text = {
      [vim.diagnostic.severity.ERROR] = " ", [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ", [vim.diagnostic.severity.INFO] = " ",
  } },
  ```
- [ ] `source = "always"` -> `source = true` (`virtual_text`).
- [ ] `util.find_git_ancestor` is deprecated -> `vim.fs.root(fname, ".git")`. Also, `project_root`/`venv_python` are only used by ruff, so they can go into the shared util (section 4).
- [ ] `vim.api.nvim_set_option("nrformats", ...)` (`vim_options.lua:66`) -> `vim.opt.nrformats = { "hex", "alpha" }`.
- [ ] `vim.loop` -> `vim.uv` (`harpoon.lua:17`).
- [ ] conform `lsp_fallback = true` -> `lsp_format = "fallback"` (`conform.lua:25,64`).
- [ ] **The `vim.notify` filter in `init.lua`** hides a deprecation instead of fixing it.
      **Fix:** remove the filter, run `:checkhealth vim.deprecated` to find which plugin calls `client.supports_method` (probably lspsaga), then remove or update that plugin.

## 4. Cleanup / dead code

- [ ] Delete `plugins/lsp/none-ls.lua` (fully commented out).
- [ ] **`ruff_cmd()` is copied 3 times** (conform, lint, lspconfig).
      **Fix:** `lua/hazot/util.lua`:
  ```lua
  local M = {}
  function M.ruff_bin(root)
      local venv = root and vim.fs.joinpath(root, ".venv/bin/ruff")
      if venv and vim.fn.executable(venv) == 1 then return venv end
      local p = vim.fn.exepath("ruff")
      if p ~= "" then return p end
      local uv_ruff = vim.fs.joinpath(vim.env.HOME, ".local/bin/ruff")
      return vim.fn.executable(uv_ruff) == 1 and uv_ruff or "ruff"
  end
  return M
  ```
  Then `require("hazot.util").ruff_bin()` in all 3 files.
- [ ] conform `black` config is unused -> delete it.
- [ ] `isort` + `ruff_format` -> `python = { "ruff_organize_imports", "ruff_format" }` (add `ruff_organize_imports = { command = util.ruff_bin() }`), then drop isort from the README.
- [ ] stylua `prepend_args` override any `stylua.toml`.
      **Fix:** remove them and add a `stylua.toml` at the repo root:
  ```toml
  indent_type = "Spaces"
  indent_width = 4
  column_width = 120
  ```
- [ ] `vim_options.lua`: delete the `BufEnter` `setlocal wrap` autocmd (wrap is already global) and the cpp FileType autocmd (same values as the globals, and `"h"` is not a filetype).
- [ ] `.luarc.json`: remove the stale globals `group` and `lsp_keymaps` (lazydev will provide `vim`).
- [ ] `vimbegood.lua`: move `vim.g.vimbegood_no_default_keybindings` into `init`.
- [ ] `cmp.lua:102`: `["<cr>"] = nil` does nothing -> delete it.

## 5. Plugins / structure

- [ ] **diffview and undotree load on `BufReadPre`**.
      **Fix:** `cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" }`; for undotree, `cmd = "UndotreeToggle", keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>" } }`, and remove the map from `remaps_plugins.lua`.
- [ ] **Comment.nvim duplicates the native `gc`/`gcc`** (0.10+).
      **Fix:** delete `comment.lua`; the `<C-_>` maps keep working with the native version.
- [ ] **vim-gitgutter -> gitsigns.nvim** (Lua, faster, blame).
  ```lua
  return {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
          on_attach = function(bufnr)
              local gs = require("gitsigns")
              local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = bufnr, desc = d }) end
              map("]h", function() gs.nav_hunk("next") end, "Next hunk")
              map("[h", function() gs.nav_hunk("prev") end, "Prev hunk")
              map("gh", gs.toggle_linehl, "Toggle hunk highlights")
              map("<leader>gp", gs.preview_hunk, "Preview hunk")
              map("<leader>gB", gs.blame_line, "Blame line")
          end,
      },
  }
  ```
  Remove the GitGutter maps from `remaps_plugins.lua:9-11`.
- [ ] **lspsaga is used only for the lightbulb** (actions-preview already handles code actions).
      **Fix:** delete `lspsaga.lua`, then check whether the `init.lua` notify filter is still needed.
- [ ] **telescope `version = "0.1.x"`** is the old branch -> remove `version` to follow master (0.11+ fixes).
- [ ] **telescope `--no-ignore`** searches `node_modules`, `.venv`, `dist`... which is slow.
      **Fix:** remove it by default, and add a dedicated map: `<leader>pF` -> `builtin.find_files({ no_ignore = true })`.
- [ ] **No which-key**, and many leader maps have no `desc`.
      **Fix:** `{ "folke/which-key.nvim", event = "VeryLazy", opts = {} }`, and add a `desc` to every map.

## 6. Missing for the TS/React/Next stack

- [ ] **No TS/JS LSP.**
      **Fix:** `npm i -g @vtsls/language-server @tailwindcss/language-server vscode-langservers-extracted yaml-language-server`, then:
  ```lua
  for _, s in ipairs({ "vtsls", "tailwindcss", "jsonls", "yamlls", "eslint" }) do
      vim.lsp.config(s, { capabilities = capabilities, on_attach = on_attach })
  end
  vim.lsp.enable({ "vtsls", "tailwindcss", "jsonls", "yamlls", "eslint" })
  ```
  With the eslint LSP, remove `eslint` from nvim-lint.
- [ ] **Missing treesitter parsers**: add `typescript`, `tsx`, `rust`, `html`, `css`, `latex` to `ensure` (`treesitter.lua:14`).
- [ ] **jsx/tsx are not linted** by nvim-lint. Covered by the eslint LSP above, or use `oxlint` (`brew install oxlint`) to go with oxfmt.
- [ ] **Folding is not configured** (`foldingRange` is declared for nvim-ufo, which is not installed).
      **Fix:** in `vim_options.lua`:
  ```lua
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldlevel = 99
  ```
  and remove the `capabilities.textDocument.foldingRange` line.

## 7. Options

- [ ] `updatetime = 50` -> `250` (50 fires CursorHold constantly).
- [ ] `update_in_insert = true` -> `false` (diagnostics flicker while typing).
- [ ] `undodir = ~/.vim/undodir` -> remove the line (the default is `stdpath("state")/undo`), and move the old history if you want to keep it.
- [ ] `completeopt` includes `preview`, which conflicts with the cmp docs window -> `"menu,menuone,noselect"`.

## 8. Repo / docs

- [ ] **`lazy-lock.json` is in `.gitignore`**, so versions cannot be reproduced across machines.
      **Fix:** remove it from `.gitignore`, commit it, and run `:Lazy restore` on the other machines.
- [ ] README: add the TS tools (section 6), remove isort, and finish the Arch section.
