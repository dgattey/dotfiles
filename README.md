# dotfiles

This is purely a way to keep my hidden files & configs in sync across computers
/up to date. But hopefully someone else finds these useful too!

## Installation

Only one prequisite: install Package Control in Sublime following directions
at <https://packagecontrol.io/installation>. Once that's done, there's a handy
script `install.sh` that should help you out. If you run it, it will print out
usage. There are two main modes:

1. `install.sh repo`: This pulls in matching files from the filesystem to
    replace the current contents in the repo, used when updating the repo with
    new additions

1. `install.sh filesystem`: This copies out the repo's files to the
    filesystem, replacing whatever's already there, and installing some useful
    `brew` packages along with it (and `brew` itself if missing)

## Contents

There are three major classes of files, and some `brew` packages

### Hidden files

1. Bash profile

1. Git attributes

1. Git config

1. Global gitignore

1. Profile

1. Vimrc

1. "personal" bin that has a command line alarm written in Java, git tab
    completion script, and Sourcery integrations

### Sublime

1. Installed Packages
1. Packages

### Xcode User Data

1. Font & color themes
1. IDEFindNavigatorScopes
1. KeyBindings
1. SearchScopes

### Brew packages

1. `thefuck` - allows for a colorful way to correct your last command

1. `pick` - nice interfaces for picking text-based options out of a list

1. `the_silver_searcher` - gives you `ag`, a MUCH better `grep`

1. `node` - Node.js, this one's obvious

1. `libyaml` - necessary for a lot of things, but most useful for some
    Cocoapods things

1. `bash-git-prompt` - really nice status from prompt about git repos

1. `go` - provides Go to the system

1. `chisel` - improves command line debugging in Xcode
