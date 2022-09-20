# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/opt/homebrew/bin:$PATH"

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

GITSTATUS_LOG_LEVEL=DEBUG

# Save history
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
bindkey '^R' history-incremental-pattern-search-backward
bindkey "^P" vi-up-line-or-history
bindkey "^N" vi-down-line-or-history

# The Fuck
eval $(thefuck --alias)

# For ag based find and replace
function agr { ag -0 -l "$1" | AGR_FROM="$1" AGR_TO="$2" xargs -r0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g'; }

# Go
export GOPATH=$HOME/go

# Secretive, secure enclave for SSH
export SSH_AUTH_SOCK=/Users/dgattey/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# NVM completion
[[ -r $NVM_DIR/bash_completion ]] && \. $NVM_DIR/bash_completion

export PATH="$PATH:/opt/homebrew/opt/python@3.8/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# 1Password op autocomplete
eval "$(op completion zsh)"; compdef _op op

if [ -f "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR="/opt/homebrew/opt/bash-git-prompt/share"
    source "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh"
fi