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

# ZSH config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# Zoxide
export _ZO_DATA_DIR=~/.zoxide
eval "$(zoxide init --cmd cd zsh)"

# Override git_prompt_info to ignore home directory git repo
function git_prompt_info() {
  local git_toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
  
  # If we're in the home directory's git repo, return empty string
  if [[ "$git_toplevel" == "$HOME" ]]; then
    return
  fi
  
  # Otherwise, call the original git_prompt_info logic
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Add the function to precmd hooks (runs before each prompt)
precmd_functions+=(_disable_home_git_prompt)

# Docker
alias dockerContainerRemove='docker rm -f $(docker ps -a -q)'
alias dockerImageRemove='docker rmi -f $(docker images -q)'
alias dockerVolumeRemove='docker volume rm $(docker volume ls -qf dangling=true)';
alias dockerRemove='dockerContainerRemove'
alias dockerSoftRemove='docker container prune -f'

# Bat
alias bat='batcat'

# Sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
