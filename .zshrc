# Oh-My-Zsh
ZSH_THEME="agnoster"
DEFAULT_USER="ilja"
plugins=(git)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit wait lucid light-mode for \
  Aloxaf/fzf-tab \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/fast-syntax-highlighting \
  MichaelAquilina/zsh-you-should-use

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
