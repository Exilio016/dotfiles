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
## Tmpfiles
For the pywal themes, I'm using systemd-tmpfiles to create the symlinks between `$HOME/.cache` and the `$HOME/.config` files.
You may need to run the following command to generate symlinks after any update:
```bash
systemd-tmpfiles --user --create
```
This command is run automatically if you used the helper script
