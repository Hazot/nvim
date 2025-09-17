# Neovim Config

## Requirements

### Ubuntu
- `cargo install ripgrep fd-find`
- `sudo apt install python3-venv -y`

After installing everything, to make markdown-preview work, I needed to do
`:call mkdp#util#install`.

### MacOS
- `brew install ripgrep fd sioyek`

### Arch Linux
- `yay -Syu ripgrep`
- `cargo install fd-find`

### Ubuntu `$HOME` Install

From `$HOME`, do:

```bash
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install
```
