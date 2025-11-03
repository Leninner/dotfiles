if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CONFIG_PATH="$HOME/dotfiles/zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  docker
  terraform
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  ansible
  alias-finder
  kubectl
  helm
  aws
)

source "$ZSH/oh-my-zsh.sh"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source "$ZSH_CONFIG_PATH/exports/exports.zsh"
source "$ZSH_CONFIG_PATH/aliases/aliases.zsh"
[ -f "$ZSH_CONFIG_PATH/keybindings/keybindings.zsh" ] && source "$ZSH_CONFIG_PATH/keybindings/keybindings.zsh"
[ -f "$ZSH_CONFIG_PATH/scripts/scripts.zsh" ] && source "$ZSH_CONFIG_PATH/scripts/scripts.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
