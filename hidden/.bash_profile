# DGATTEY - BASH PROFILE WITH SHORTCUTS AND FUNCTIONS
# ---------------------------------------------------

# PATH manipulations and exported paths
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:/Users/dgattey/.bin

# Shortcuts to common places + apps & extensions
DEV_FOLDER=/Users/dgattey/Dropbox/dev/
alias dev='cd $DEV_FOLDER'

# Shortcuts (apps, extensions, etc)
alias brew-prune='while true; do brew uninstall --force $(brew leaves | pick); done;' #interactively prunes unused brew packages
alias show-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias review='git review create -guess-desc -o --no-prompt'

# Fixing Xcode & basic setup
function vios-reset {
    echo -e "\033[0;36mClearing derived data\033[m" &&
    rm -rfd ~/Library/Developer/Xcode/DerivedData/* &&
    echo -e "\033[0;36mRemoving Xcode caches\033[m" &&
    rm -rfd ~/Library/Caches/com.apple.dt.Xcode/* &&
    echo -e "\033[0;36mDeleting voyager.xcworkspace\033[m" &&
    rm -rf voyager.xcworkspace &&
    echo -e "\033[0;33mInstalling pods\033[m" &&
    ligradle clean podinstall &&
    echo -e "\033[0;32mDone!\033[m" &&
    open voyager.xcworkspace
}

function vios-checkout {
    echo "TODO: USAGE needs one arg"
    echo -e "\033[0;36mDownloading project\033[m" &&
    mint checkout voyager-ios &&
    echo -e "\033[0;36mRenaming project\033[m" &&
    mv voyager-ios_trunk vios-$1 &&
    cd vios-$1 &&
    echo -e "\033[0;33mInstalling pods\033[m" &&
    ligradle clean podinstall &&
    echo -e "\033[0;32mDone!\033[m" &&
    open voyager.xcworkspace #nohup /Applications/Xcode.app/Contents/MacOS/Xcode voyager.xcworkspace &>/dev/null &
}

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

# Because we get something else otherwise
export BROWSER=/Applications/Firefox.app/Contents/MacOS/firefox

# CMake
export PATH=/Applications/CMake.app/Contents/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
