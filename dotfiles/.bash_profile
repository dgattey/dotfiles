# DGATTEY - BASH PROFILE WITH SHORTCUTS AND FUNCTIONS
# ---------------------------------------------------

# PATH manipulations and exported paths
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:/Users/dgattey/.bin

# Git autocomplete
source ~/.bin/git-completion.bash

# The FUCK
eval "$(thefuck --alias)"

# Go configs
export GOPATH="/Users/dgattey/.golang/"
export PATH="$GOPATH/bin:$PATH"

# Pretty git prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_START="$DG_PROMPT"
  GIT_PROMPT_END=""
  GIT_PROMPT_THEME=Single_line
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Remove duplicates in PATH:
PATH="$(printf "%s" "${PATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')"
PATH="${PATH%:}"    # remove trailing colon"
export PATH

# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Python3 as default python
alias python='python3'
alias js-backend='cd ~/checkouts/jumpstart-backend; source ./venv/bin/activate'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

. "$HOME/.cargo/env"
