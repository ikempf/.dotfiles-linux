# Windows setup

## Chocolatey
Install chocolatey:
https://chocolatey.org/install#individual

## Install WSL
```
wsl --install
wsl --install -d Debian
```

## Windows tooling
```
choco install microsoft-windows-terminal
choco install jetbrainstoolbox
```

## DEV tooling
```
apt install bat
apt install git
apt install lazygit
apt install curl
apt install zip
apt install unzip
apt install telnet
apt install zoxide
apt install silversearcher-ag
apt install mitmproxy
npm install -g @mermaid-js/mermaid-cli
```

## OhMyZsh
```
apt install zsh
Install Oh-my-zsh
```

## LazyVim
```
NerdFont:q
apt install vim
apt install fzf
apt install ripgrep
apt install fd
apt install build-essential
https://www.lazyvim.org/
```

## SDK man
```
Install sdkman
sdk install maven
sdk install java
sdk install springboot
```

## Git config
Create a new github/github.pub ssh key.
Configure ssh/config to use the key for github.com

```
git config --global user.email "ilja.kempf@pm.me"
git config --global user.name "ilja"
```

## AI tools
```
Install claude code
Install codex
Install opencode

## Theme
Windows terminal: .config/windows-terminal/settings.json

```

## Checkout this repository
```
git init .
git remote add origin git@github.com:ikempf/.dotfiles-win.git
git pull origin master
git branch --set-upstream-to=origin/master master
```
