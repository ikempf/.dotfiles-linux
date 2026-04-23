# Linux setup

## Bootstrap
```
ssh-keygen -t ed25519 -C "<email>"
git config --global user.email <>
git config --global user.name <>
git clone git@github.com:ikempf/.dotfiles-linux.git ~/dotfiles
```

## Prerequisites
```
Install homebrew
Install Oh-my-zsh
```

## Install dotfiles
```
source ~/dotfiles/zsh/zsh-lib/.zshrc.sync
local-sync
```

## Manual installs
```
Install jetbrainstoolbox
Install alacritty
Install NerdFont
Install tpm
Install LazyVim
```

