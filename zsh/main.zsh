if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git docker terraform z zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete ansible alias-finder kubectl helm aws)

source $ZSH/oh-my-zsh.sh

export ZSH_CONFIG_PATH=$HOME/dotfiles/zsh

# Load custom aliases
source "$ZSH_CONFIG_PATH/aliases/aliases.zsh"

# Load functions
source "$ZSH_CONFIG_PATH/functions/functions.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=/home/leninner/.meteor:$PATH

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

export PATH=$PATH:~/.local/bin

# Golang
export PATH=$PATH:/usr/local/go/bin

## Golang Live Reloading with Air 
alias air='$(go env GOPATH)/bin/air'

# Maven
MAVEN_HOME=$HOME/maven
export PATH=$MAVEN_HOME/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/leninner/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/leninner/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/leninner/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/leninner/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Flutter path
export PATH="/home/leninner/flutter/flutter/bin:$PATH"

# Command line tools - ANDROID
export PATH="/home/leninner/Android/Sdk/cmdline-tools/bin:$PATH"

# Load Powerlevel10k theme configuration
[[ ! -f ~/.p10k.zsh ]] || source $HOME/.p10k.zsh
