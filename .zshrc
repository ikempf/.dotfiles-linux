source $HOME/.oh-my-zsh/oh-my-zsh.sh

# ZSH plugins
export ZPLUG_HOME=~/.zplug
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi
source $ZPLUG_HOME/init.zsh

## ZPlug init
source ~/.zplug/init.zsh

## ZSH Plugins
zplug "plugins/git", from:oh-my-zsh
zplug "Aloxaf/fzf-tab"
zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "MichaelAquilina/zsh-you-should-use" 
 
## Theme
zplug "agnoster/agnoster-zsh-theme", as:theme
DEFAULT_USER="ilja"

## Install plugins if not installed
if ! zplug check; then
  zplug install
fi

## Load plugins
zplug load

# Add binaries
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/snap/bin"
export PATH=$HOME/.opencode/bin:$PATH

# Zoxide
export _ZO_DATA_DIR=~/.zoxide
eval "$(zoxide init --cmd cd zsh)"

# Override prompt_git for agnoster theme to ignore home directory git repo
functions[_original_prompt_git]=$functions[prompt_git]
function prompt_git() {
  local git_toplevel=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ "$git_toplevel" == "$HOME" ]]; then
    return
  fi

  _original_prompt_git
}

# Docker
alias dockerContainerRemove='docker rm -f $(docker ps -a -q)'
alias dockerImageRemove='docker rmi -f $(docker images -q)'
alias dockerVolumeRemove='docker volume rm $(docker volume ls -qf dangling=true)';
alias dockerRemove='dockerContainerRemove'
alias dockerSoftRemove='docker container prune -f'

# Bat
alias bat='batcat'

# Tmux
alias tmuxn='tmux new -s' 
alias tmuxa='tmux a -t' 
alias tmuxd='tmux detach'
tx() {
  if tmux has-session 2>/dev/null; then

    tmux attach \; choose-tree -s
  else
    tmux new
  fi
}

# Mise
eval "$(mise activate zsh)"

# Source private local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

