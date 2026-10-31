# DOTFILES
This project contains my dotfiles to be installed using `gnu stow`.

## Usage
First you need to clone this repository into a folder on your `$HOME` directory.
```bash
git clone https://github.com/Exilio016/dotfiles.git ~/dotfiles
cd ~/dotfiles
```
Each folder contains the configuration for that program. For example to apply the config for Neovim do:
```bash
stow --no-folding nvim
```
You can apply all configs using the helper script:
```bash
./apply.sh
```
