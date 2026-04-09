# Linux setup

## Checkout this repository
```bash
ssh-keygen -t ed25519 -C "<email>"
git config --global user.email <>
git config --global user.name <>
git clone git@github.com:ikempf/.dotfiles-linux.git ~/dotfiles
```

## Install dotfiles with stow
```bash
# Install stow first
brew install stow
cd ~/dotfiles

# Core packages (all machines)
stow zsh atuin mise nvim tmux

# WSL/Windows-only
stow alacritty whim windows-terminal wsl

# macOS/Linux with Homebrew
stow brew

# Remove a package
stow -D nvim
```

## Dev tooling
```
Install jetbrainstoolbox
Install homebrew
```

## Sync tooling
```
local-sync
```

## Terminal
```
Install alacritty
Install tpm
```

## OhMyZsh
```
Install Oh-my-zsh
```

## LazyVim
```
Install NerdFont
Install tree-sitter-cli
Install LazyVim
```

# WSL
## Theme 
Windows terminal: .config/windows-terminal/settings.json
## Alacritty
Update config and config path

