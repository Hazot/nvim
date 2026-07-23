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

### Ubuntu `$HOME` Install

From `$HOME`, do:

```bash
git clone https://github.com/neovim/neovim.git
cd neovim
make distclean
make CMAKE_EXTRA_FLAGS="-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install
```

Then add `export PATH="$HOME/neovim/bin:$PATH"` to your shell config.
