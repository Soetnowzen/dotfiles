here := $(shell pwd)

help:
	@echo "Select a target"
	@make -rpn | sed -n -e '/^$$/ { n ; /^[^ ]*:/p}' | egrep -v '^.PHONY' | egrep -v '^all'

all:
	bash vim vimperator git mintty tcsh tmux gdb input sumatra_pdf

bash:
	ln -fsn $(here)/bash/my.bashrc $(HOME)/.bashrc

gdb:
	ln -fsn $(here)/gdb/.gdbinit $(HOME)/.gdbinit

git:
	ln -fsn $(here)/gitconfig/.gitconfig $(HOME)/.gitconfig
	mkdir -p $(HOME)/.git_template/hooks
	ln -fsn $(here)/gitconfig/pre-commit-conflict $(HOME)/.git_template/hooks/pre-commit

input:
	ln -fsn $(here)/input/.inputrc $(HOME)/.inputrc

mintty:
	ln -fsn $(here)/mintty/dark.minttyrc $(HOME)/.minttyrc

sumatra_pdf:
	ln -fsn $(here)/sumatra_pdf/SumatraPDF-settings.txt $(HOME)/AppData/Roaming/SumatraPDF/.

tcsh:
	ln -fsn $(here)/tcsh/my.tcshrc $(HOME)/.tcshrc

tmux:
	ln -fsn $(here)/tmux/my-tmux.conf $(HOME)/.tmux.conf

vim:
	ln -fsn $(here)/vim/my.vimrc $(HOME)/.vimrc
	if [ -d $(HOME)/.vim/bundle/Vundle.vim ]; \
		then echo "Vundle exists"; \
		else git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim; \
	fi
	mkdir -p $(HOME)/.vim/syntax
	ln -fsn $(here)/vim/syntax/*.vim $(HOME)/.vim/syntax/.
	mkdir -p $(HOME)/.vim/.backup
	vim +PluginInstall +qall
	mkdir -p $(HOME)/.vim/custom
	ln -fsn $(here)/vim/configurations/*.vim $(HOME)/.vim/custom/.

vimperator:
	ln -fsn $(here)/vimperator/my.vimperatorrc $(HOME)/.vimperatorrc
	mkdir -p $(HOME)/.vimperator/colors
	ln -fsn $(here)/vimperator/colors/solarized_dark.vimp $(HOME)/.vimperator/colors/solarized_dark.vimp

.PHONY:
	bash gdb git input mintty sumatra_pdf tcsh tmux vim vimperator
