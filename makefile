here := $(shell pwd)

help:
	@echo "Select a target"
	@make -rpn | sed -n -e '/^$$/ { n ; /^[^ ]*:/p}' | egrep -v '^.PHONY' | egrep -v '^all'
	@echo "Choose a platform (arch/windows)"

all:
	bash vim vimperator

bash:
	ln -fsn $(here)/bash/bash_aliases $(HOME)/.bash_aliases
	#ln -fsn $(here)/bash/bash_profile $(HOME)/.bash_profile
	#ln -fsn $(here)/bash/bashrc $(HOME)/.bashrc

vim:
	ln -fsn $(here)/vim/vimrc $(HOME)/.vimrc
	if [ -d $(HOME)/.vim/bundle/Vundle.vim ]; \
		then echo "Vundle exists"; \
		else git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim; \
	fi
	mkdir -p $(HOME)/.vim/.backup
	vim +PluginInstall +qall

vimperator:
	ln -fsn $(here)/vimperator/vimperatorrc $(HOME)/.vimperatorrc
	ln -fsn $(here)/vimperator/colors/solarized_dark.vimp $(HOME)/.vimperator/colors/solarized_dark.vimp

.PHONY: bash vim vimperator
