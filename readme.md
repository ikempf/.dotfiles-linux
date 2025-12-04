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
apt install vim
apt install git
apt install curl
apt install zip
apt install maven
apt install zoxide
apt install silversearcher-ag
apt install bat
apt install mitmproxy 
```

```
Install Oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git
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
```

## Checkout this repository
git init .
git remote add origin git@github.com:ikempf/.dotfiles-win.git
git pull origin master
git branch --set-upstream-to=origin/master master
