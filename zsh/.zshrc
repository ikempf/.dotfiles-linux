# Oh-My-Zsh
ZSH_THEME="agnoster"
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
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="/opt/nvim:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# Evals
## Mise (needed in non-interactive shells too)
command -v mise &>/dev/null && eval "$(mise activate zsh)"
## Interactive-only evals
if [[ -o interactive ]]; then
  ## Zoxide
  command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"
  ## Brew
  command -v brew &>/dev/null && eval "$(brew shellenv zsh)"
  ## Atuin
  command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"
  ## Tirith
  #command -v tirith &>/dev/null && eval "$(tirith init --shell zsh)"
fi

# Editor
export EDITOR=nvim
export VISUAL=nvim
export GIT_EDITOR=nvim
export SQL_EDITOR=nvim

# Aliases
## Docker
alias dockerContainerRemove='docker rm -f $(docker ps -a -q)'
alias dockerImageRemove='docker rmi -f $(docker images -q)'
alias dockerVolumeRemove='docker volume rm $(docker volume ls -qf dangling=true)';
alias dockerRemove='dockerContainerRemove'
alias dockerSoftRemove='docker container prune -f'
## Bat
alias bat='batcat'
## Tmux
alias txd='tmux detach'
## Eza
if command -v eza &> /dev/null; then
  EZA_IGNORE=".git|.idea|.claude|__pycache__|.venv|node_modules|.mypy_cache|.pytest_cache|.ruff_cache|.tox|.nox|.coverage|.cache|dist|.eggs|*.egg-info|.next|.nuxt|.turbo|target"
  alias ls="eza --icons --group-directories-first --grid"
  alias la="eza --icons --group-directories-first -lhA"
  alias lst="eza --icons --group-directories-first --ignore-glob=\"$EZA_IGNORE\" --tree -A"
  alias lat="eza --icons --group-directories-first --ignore-glob=\"$EZA_IGNORE\" --tree -lhA"
fi
## Other
alias c='clear'
alias lzg='lazygit'
alias lzd='lazydocker'
alias lzs='lazysql'

# Local private configuration
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -z "$DEFAULT_USER" ]] && echo "warning: DEFAULT_USER is not set (define it in ~/.zshrc.local)"

# LS Colors (generated with: vivid generate catppuccin-frappe)
source "$HOME/dotfiles/zsh/zsh-lib/.zshrc.ls_colors"

# Functions
source "$HOME/dotfiles/zsh/zsh-lib/.zshrc.functions"
source "$HOME/dotfiles/zsh/zsh-lib/.zshrc.sync"
