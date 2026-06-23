# Linux setup

## Bootstrap
```
ssh-keygen -t ed25519 -C "<email>"
git clone git@github.com:ikempf/.dotfiles-linux.git ~/dotfiles
```

## Prerequisites
```
Install homebrew
Install zsh (brew)
Install Oh-my-zsh
chsh -s /usr/bin/zsh
```

## Install dotfiles
```
source ~/dotfiles/zsh/zsh-lib/.zshrc.sync
local-sync
```

## Machine-local  identity
Setup local `.zshrc.local` and `.gitconfig.local`

## Manual installs
```
Install jetbrainstoolbox
Install alacritty
Install NerdFont
Install tpm
Install LazyVim
```

