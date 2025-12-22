# Plugins
plugins=(
	git
	zsh-autosuggestions
	fast-syntax-highlighting
	zsh-you-should-use
)

# Add binaries
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:/opt/nvim/"

# ZSH config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
DEFAULT_USER="ilja"
source $ZSH/oh-my-zsh.sh

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

# Source private local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
