here := $(shell pwd)

help:
	@echo "Select a target"
	@make -rpn | sed -n -e '/^$$/ { n ; /^[^ ]*:/p}' | egrep -v '^.PHONY' | egrep -v '^all'
	@echo "Choose a platform (debian/windows)"

all:
	bash vim vimperator git mintty tcsh tmux

bash:
	ln -fsn $(here)/bash/my.bashrc $(HOME)/.bashrc

vim:
	ln -fsn $(here)/vim/my.vimrc $(HOME)/.vimrc
	if [ -d $(HOME)/.vim/bundle/Vundle.vim ]; \
		then echo "Vundle exists"; \
		else git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim; \
	fi
	mkdir -p $(HOME)/.vim/syntax
	ln -fsn $(here)/vim/log.vim $(HOME)/.vim/syntax/log.vim
	mkdir -p $(HOME)/.vim/.backup
	vim +PluginInstall +qall

vimperator:
	ln -fsn $(here)/vimperator/my.vimperatorrc $(HOME)/.vimperatorrc
	mkdir -p $(HOME)/.vimperator/colors
	ln -fsn $(here)/vimperator/colors/solarized_dark.vimp $(HOME)/.vimperator/colors/solarized_dark.vimp

git:
	ln -fsn $(here)/gitconfig/.gitconfig $(HOME)/.gitconfig

mintty:
	ln -fsn $(here)/mintty/dark.minttyrc $(HOME)/.minttyrc

tcsh:
	ln -fsn $(here)/tcsh/my.tcshrc $(HOME)/.tcshrc

tmux:
	ln -fsn $(here)/tmux/my-tmux.conf $(HOME)/.tmux.conf

.PHONY: bash vim vimperator git mintty tcsh tmux
