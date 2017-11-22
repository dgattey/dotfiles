#!/bin/bash

echo "Beginning install of all hidden files..." &&
mkdir -p ~/.bin &&
cp ./hidden/.bash_profile ~/ &&
cp -R ./hidden/.bin/* ~/.bin &&
cp ./hidden/.git* ~/ &&
cp ./hidden/.profile ~/ &&
cp ./hidden/.vimrc ~/ &&

echo "Beginning install of Sublime files..." &&
mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User &&
cp -R ./sublime/User/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/ &&

echo "Beginning install of Xcode files..." &&
mkdir -p ~/Library/Developer/Xcode/ &&
cp -R ./xcode/Templates/ ~/Library/Developer/Xcode/ &&
cp -R ./xcode/UserData ~/Library/Developer/Xcode/ &&

echo "Installing brew" &&
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
brew install thefuck &&
brew install pick &&
brew install the_silver_searcher &&
brew install node &&
brew install libyaml &&

echo "Done installing! Good to goooo. All you need to do is source the bash profile"
