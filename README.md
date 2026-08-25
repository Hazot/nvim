# Neovim Config

## Requirements

> **Mason is optional.** This config does **not** rely on Mason to install
> anything (`ensure_installed = {}`). Every language server, formatter, and
> linter is resolved from `$PATH`, so it works the same on any machine with or
> without a working Mason — install the tools below with your system package
> manager. `:Mason` is still available as a convenience if you want it.

### Tooling reference (must be on `$PATH`)

| Role | Tools |
| ---------- | ------------------------------------------------------------------------------- |
| LSP | `ty`, `ruff`, `lua-language-server`, `clangd`, `rust-analyzer` |
| Formatters | `ruff`, `isort`, `mdformat`, `oxfmt`, `stylua`, `shfmt`, `clang-format`, `pyproject-fmt` |
| Linters | `ruff`, `markdownlint`, `eslint`, `clippy`, `clang-tidy`, `chktex` |

### Ubuntu

- `cargo install ripgrep fd-find tree-sitter-cli stylua`
- `sudo apt install python3-venv clangd clang-format clang-tidy shfmt chktex -y`
- `uv tool install ruff && uv tool install isort && uv tool install pyproject-fmt && uv tool install ty && uv tool install mdformat`
- `npm install -g markdownlint-cli eslint`
- `brew install oxfmt` (linuxbrew; formats json/yaml/html/css/js/ts — not cargo-installable)
- `rustup component add clippy rust-analyzer`
- lua-language-server: `brew install lua-language-server` (linuxbrew), or grab a
  release from <https://github.com/LuaLS/lua-language-server/releases> and put it
  on `$PATH`

After installing everything, to make markdown-preview work, I needed to do
`:call mkdp#util#install()`.

### MacOS

- `brew install ripgrep fd sioyek`
- `brew install llvm shfmt stylua lua-language-server oxfmt`
- `rustup component add clippy rust-analyzer`
- `npm install -g eslint markdownlint-cli`
- `uv tool install ruff && uv tool install isort && uv tool install pyproject-fmt && uv tool install ty && uv tool install mdformat`
- clangd ships with `llvm` (above); symlink it if it's not already on `$PATH`
- `ln -sf /opt/homebrew/opt/llvm/bin/clang-tidy /opt/homebrew/bin/clang-tidy`
- `ln -sf "$HOME/.cargo/bin/cargo-clippy" "$HOME/.cargo/bin/clippy"`
- `brew install --cask basictex`
- `sudo /Library/TeX/texbin/tlmgr install chktex`

### Arch Linux

- `yay -Syu ripgrep`
- `cargo install fd-find`

### Ubuntu: build Neovim from source

Source lives in `~/src/neovim` (all my from-source builds are in `~/src`; see
`~/src/README.md`). Install prefix is `$HOME/.local`, whose `bin/` is already on
`$PATH` — so no symlink and no `PATH` edit is needed.

```bash
sudo apt install ninja-build gettext cmake curl build-essential -y
git clone https://github.com/neovim/neovim.git ~/src/neovim
cd ~/src/neovim
git checkout stable                 # or a tag, e.g. v0.12.5
make CMAKE_EXTRA_FLAGS="-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$HOME/.local"
make install
```

The prefix must go **inside `CMAKE_EXTRA_FLAGS`** — the Makefile greps it out of
that variable. Don't add `make distclean` out of habit: it wipes `.deps` and
forces a full dependency rebuild. Changing the prefix alone doesn't need it, the
`checkprefix` target re-runs CMake on its own when the cached prefix differs.

**Moving the repo is the exception**: CMake bakes absolute source paths into
`build/CMakeCache.txt` and `.deps/CMakeCache.txt`, so a relocated tree dies with
"does not match the source used to generate cache". Then you do need
`make distclean` and a full dependency rebuild.

To rebuild after a `git pull`, repeat the same two `make` lines.

#### One-time migration off the old prefix

The old build used `-DCMAKE_INSTALL_PREFIX=$HOME/neovim`, i.e. it installed into
its own source tree, and `~/.local/bin/nvim` was a **symlink** to it. Before
re-installing with the `$HOME/.local` prefix, delete that symlink — otherwise
`cmake --install` follows it and writes back into the source tree:

```bash
rm ~/.local/bin/nvim                 # symlink, not a real binary
rm -rf ~/src/neovim/bin ~/src/neovim/share   # stale install inside the repo
```

Those two directories are also why `git status` in the repo shows untracked
`bin/` and `share/`.

#### If you prefer a self-contained prefix instead

Keeping the install inside the source tree works too, and then you *do* need the
symlink, because `~/src/neovim/bin` isn't on `$PATH`:

```bash
make CMAKE_EXTRA_FLAGS="-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$HOME/src/neovim"
make install
ln -sfn ~/src/neovim/bin/nvim ~/.local/bin/nvim
```

`ln -sfn` is deliberate: `-f` replaces an existing link, `-n` stops it from
being created *inside* the old target directory if one is already there.
