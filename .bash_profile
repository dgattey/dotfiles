# DGATTEY - BASH PROFILE WITH SHORTCUTS AND FUNCTIONS
# ---------------------------------------------------

# PATH manipulations and exported paths
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/Users/dgattey/.brew/bin:$PATH # custom brew folder
export PATH=$PATH:/Users/dgattey/.bin

# Shortcuts to common places + apps & extensions
DEV_FOLDER=/Users/dgattey/Dropbox/dev/
alias dev='cd $DEV_FOLDER'

# Shortcuts (apps, extensions, etc)
alias brew-prune='while true; do brew uninstall --force $(brew leaves | pick); done;' #interactively prunes unused brew packages
alias show-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# NPM help
function npm-upgrade-all-g {
    for f in /usr/local/lib/node_modules/*; do 
        npm -g upgrade ${f##*/}; 
    done;
}
function npm-upgrade-all {
    for f in $(pwd)/node-modules/*; do 
        npm upgrade ${f##*/};
    done;
}

# Colors for prompt and ls
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33m\]\W\[\033[m\] $ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Git autocomplete
source ~/.bin/git-completion.bash

# The FUCK
eval "$(thefuck --alias)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Ruby configs
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Go configs
export GOPATH="/Users/dgattey/.golang/"
export PATH="$GOPATH/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
