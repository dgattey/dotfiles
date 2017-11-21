#!/bin/bash

echo "Beginning install of all hidden files..." &&
mkdir -p ~/.bin &&
cp ./hidden/.bash_profile ~/ &&
cp -R ./hidden/.bin/* ~/.bin &&
cp ./hidden/.git* ~/ &&
cp ./hidden/.profile ~/ &&
cp ./hidden/.vimrc ~/ &&
source ~/.bash_profile &&

echo "Beginning install of Sublime files..." &&
mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User &&
cp -R ./sublime/User/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/ &&

echo "Beginning install of Xcode files..." &&
mkdir -p ~/Library/Developer/Xcode/ &&
cp -R ./xcode/Templates/ ~/Library/Developer/Xcode/ &&
cp -R ./xcode/UserData ~/Library/Developer/Xcode/ &&

echo "Done installing! Good to goooo"
