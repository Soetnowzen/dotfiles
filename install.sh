#! /bin/bash

ln -fsn ~/dotfiles/bash/my.bashrc ~/.bashrc
ln -fsn ~/dotfiles/input/.inputrc ~/.inputrc
sudo apt-get update && sudo apt-get install -y bc