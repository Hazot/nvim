# Neovim Config

## Requirements

### Ubuntu

- `cargo install ripgrep fd-find`
- `sudo apt install python3-venv -y`
- `cargo install tree-sitter-cli`
- `uv tool install ruff`
- `npm install -g markdownlint-cli`
- `sudo apt install chktex`

After installing everything, to make markdown-preview work, I needed to do
`:call mkdp#util#install()`.

### MacOS

- `brew install ripgrep fd sioyek`
- `brew install llvm shfmt stylua`
- `rustup component add clippy`
- `npm install -g eslint prettier markdownlint-cli`
- `uv tool install ruff && uv tool install isort && uv tool install pyproject-fmt`
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
