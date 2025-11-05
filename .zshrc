# Plugins
plugins=(git)

# Use binaries
export PATH="$HOME/.local/bin:$PATH"

# ZSH config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# Zoxide
export _ZO_DATA_DIR=~/.zoxide
eval "$(zoxide init --cmd cd zsh)"

# Sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
