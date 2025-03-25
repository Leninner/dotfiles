if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git docker terraform z zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting ansible alias-finder kubectl helm aws)

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
export PATH="$HOME/.meteor:$PATH"

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

# Load Powerlevel10k theme configuration
[[ ! -f ~/.p10k.zsh ]] || source $HOME/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Load Angular CLI autocompletion.
source <(ng completion script)

# Cursor AI IDE launcher function
function cursor() {
    local args=""
    if [ $# -eq 0 ]; then
        args=$(pwd)
    else
        for arg in "$@"; do
            args="$args $arg"
        done
    fi
    local executable=$(find /opt/cursor/cursor.AppImage -type f)
    (nohup $executable --no-sandbox "$args" >/dev/null 2>&1 &)
}
