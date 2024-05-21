#! /bin/bash

sudo apt-get update && sudo apt-get install -y bc
ln -fsn ~/dotfiles/bash/my.bashrc ~/.bashrc
ln -fsn ~/dotfiles/input/.inputrc ~/.inputrc