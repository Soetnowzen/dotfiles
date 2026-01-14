# Dotfiles installation makefile
here := $(shell pwd)
UNAME := $(shell uname)

# Default target
.DEFAULT_GOAL := help

# Colors for output
RED    := \033[31m
GREEN  := \033[32m
YELLOW := \033[33m
BLUE   := \033[34m
RESET  := \033[0m

help: ## Show this help message
	@echo "$(BLUE)Dotfiles Installation$(RESET)"
	@echo ""
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-15s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Usage: make <target>"

all: ## Install all dotfiles
	@$(MAKE) bash vim vimperator git mintty tcsh tmux gdb input sumatra_pdf emacs keyboard

install: all ## Alias for 'all'

bash: ## Install bash configuration
	@echo "$(YELLOW)Installing bash config...$(RESET)"
	@ln -fsn $(here)/bash/my.bashrc $(HOME)/.bashrc
	@echo "$(GREEN)✓ Bash config installed$(RESET)"

gdb: ## Install GDB configuration  
	@echo "$(YELLOW)Installing GDB config...$(RESET)"
	@ln -fsn $(here)/gdb/.gdbinit $(HOME)/.gdbinit
	@echo "$(GREEN)✓ GDB config installed$(RESET)"

git: ## Install Git configuration
	@echo "$(YELLOW)Installing Git config...$(RESET)"
	@ln -fsn $(here)/gitconfig/.gitconfig $(HOME)/.gitconfig
	@mkdir -p $(HOME)/.git_template/hooks
	@ln -fsn $(here)/gitconfig/pre-commit-conflict $(HOME)/.git_template/hooks/pre-commit
	@ln -fsn $(here)/gitconfig/.gitk $(HOME)/.gitk
	@echo "$(GREEN)✓ Git config installed$(RESET)"

input: ## Install readline/input configuration
	@echo "$(YELLOW)Installing input config...$(RESET)"
	@ln -fsn $(here)/input/.inputrc $(HOME)/.inputrc
	@echo "$(GREEN)✓ Input config installed$(RESET)"

mintty: ## Install Mintty configuration (Windows)
	@echo "$(YELLOW)Installing Mintty config...$(RESET)"
	@if [ "$(UNAME)" = "MINGW64_NT" ] || [ "$(UNAME)" = "MSYS_NT" ]; then \
		ln -fsn $(here)/mintty/dark.minttyrc $(HOME)/.minttyrc; \
		echo "$(GREEN)✓ Mintty config installed$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ Mintty is Windows-only, skipping$(RESET)"; \
	fi

sumatra_pdf: ## Install SumatraPDF configuration (Windows)
	@echo "$(YELLOW)Installing SumatraPDF config...$(RESET)"
	@if [ "$(UNAME)" = "MINGW64_NT" ] || [ "$(UNAME)" = "MSYS_NT" ]; then \
		mkdir -p $(HOME)/AppData/Roaming/SumatraPDF; \
		ln -fsn $(here)/sumatra_pdf/SumatraPDF-settings.txt $(HOME)/AppData/Roaming/SumatraPDF/.; \
		echo "$(GREEN)✓ SumatraPDF config installed$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ SumatraPDF is Windows-only, skipping$(RESET)"; \
	fi

tcsh: ## Install tcsh configuration
	@echo "$(YELLOW)Installing tcsh config...$(RESET)"
	@ln -fsn $(here)/tcsh/my.tcshrc $(HOME)/.tcshrc
	@echo "$(GREEN)✓ tcsh config installed$(RESET)"

tmux: ## Install tmux configuration
	@echo "$(YELLOW)Installing tmux config...$(RESET)"
	@ln -fsn $(here)/tmux/my-tmux.conf $(HOME)/.tmux.conf
	@echo "$(GREEN)✓ tmux config installed$(RESET)"

vim: ## Install Vim configuration
	@echo "$(YELLOW)Installing Vim config...$(RESET)"
	@ln -fsn $(here)/vim/my.vimrc $(HOME)/.vimrc
	@if [ -d $(HOME)/.vim/bundle/Vundle.vim ]; then \
		echo "$(BLUE)Vundle already exists$(RESET)"; \
	else \
		echo "$(BLUE)Cloning Vundle...$(RESET)"; \
		git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim; \
	fi
	@mkdir -p $(HOME)/.vim/syntax
	@ln -fsn $(here)/vim/syntax/*.vim $(HOME)/.vim/syntax/.
	@mkdir -p $(HOME)/.vim/.backup
	@mkdir -p $(HOME)/.vim/custom  
	@ln -fsn $(here)/vim/configurations/*.vim $(HOME)/.vim/custom/.
	@echo "$(BLUE)Installing Vim plugins...$(RESET)"
	@vim +PluginInstall +qall
	@echo "$(GREEN)✓ Vim config installed$(RESET)"

vimperator: ## Install Vimperator configuration
	@echo "$(YELLOW)Installing Vimperator config...$(RESET)"
	@ln -fsn $(here)/vimperator/my.vimperatorrc $(HOME)/.vimperatorrc
	@mkdir -p $(HOME)/.vimperator/colors
	@if [ -f $(here)/vimperator/colors/solarized_dark.vimp ]; then \
		ln -fsn $(here)/vimperator/colors/solarized_dark.vimp $(HOME)/.vimperator/colors/solarized_dark.vimp; \
	fi
	@echo "$(GREEN)✓ Vimperator config installed$(RESET)"

emacs: ## Install Emacs configuration  
	@echo "$(YELLOW)Installing Emacs config...$(RESET)"
	@ln -fsn $(here)/emacs $(HOME)/.emacs.d
	@echo "$(GREEN)✓ Emacs config installed$(RESET)"

keyboard: ## Install keyboard configuration
	@echo "$(YELLOW)Installing keyboard config...$(RESET)"
	@ln -fsn $(here)/keyboard/.my_keyboard $(HOME)/.my_keyboard
	@echo "$(GREEN)✓ Keyboard config installed$(RESET)"

# Utility targets
check: ## Check which configs are already installed
	@echo "$(BLUE)Checking dotfile installations:$(RESET)"
	@echo -n "Bash:       "; [ -L $(HOME)/.bashrc ] && echo "$(GREEN)✓ Installed$(RESET)" || echo "$(RED)✗ Not installed$(RESET)"
	@echo -n "Vim:        "; [ -L $(HOME)/.vimrc ] && echo "$(GREEN)✓ Installed$(RESET)" || echo "$(RED)✗ Not installed$(RESET)"
	@echo -n "Git:        "; [ -L $(HOME)/.gitconfig ] && echo "$(GREEN)✓ Installed$(RESET)" || echo "$(RED)✗ Not installed$(RESET)"
	@echo -n "Tmux:       "; [ -L $(HOME)/.tmux.conf ] && echo "$(GREEN)✓ Installed$(RESET)" || echo "$(RED)✗ Not installed$(RESET)"
	@echo -n "Input:      "; [ -L $(HOME)/.inputrc ] && echo "$(GREEN)✓ Installed$(RESET)" || echo "$(RED)✗ Not installed$(RESET)"
	@echo -n "Emacs:      "; [ -L $(HOME)/.emacs.d ] && echo "$(GREEN)✓ Installed$(RESET)" || echo "$(RED)✗ Not installed$(RESET)"

backup: ## Backup existing dotfiles before installation
	@echo "$(YELLOW)Creating backup of existing dotfiles...$(RESET)"
	@mkdir -p $(HOME)/dotfiles-backup-$(shell date +%Y%m%d-%H%M%S)
	@[ -f $(HOME)/.bashrc ] && cp $(HOME)/.bashrc $(HOME)/dotfiles-backup-*/bashrc.bak || true
	@[ -f $(HOME)/.vimrc ] && cp $(HOME)/.vimrc $(HOME)/dotfiles-backup-*/vimrc.bak || true
	@[ -f $(HOME)/.gitconfig ] && cp $(HOME)/.gitconfig $(HOME)/dotfiles-backup-*/gitconfig.bak || true
	@[ -f $(HOME)/.tmux.conf ] && cp $(HOME)/.tmux.conf $(HOME)/dotfiles-backup-*/tmux.conf.bak || true
	@echo "$(GREEN)✓ Backup completed$(RESET)"

clean: ## Remove installed symlinks (uninstall)
	@echo "$(YELLOW)Removing dotfile symlinks...$(RESET)"
	@rm -f $(HOME)/.bashrc $(HOME)/.vimrc $(HOME)/.gitconfig $(HOME)/.tmux.conf
	@rm -f $(HOME)/.inputrc $(HOME)/.tcshrc $(HOME)/.gdbinit $(HOME)/.minttyrc
	@rm -f $(HOME)/.vimperatorrc $(HOME)/.my_keyboard
	@rm -f $(HOME)/.emacs.d
	@echo "$(GREEN)✓ Dotfiles uninstalled$(RESET)"

update: ## Update dotfiles repository
	@echo "$(YELLOW)Updating dotfiles repository...$(RESET)"
	@git pull origin master
	@echo "$(GREEN)✓ Repository updated$(RESET)"

# Core configurations that most people want
essential: bash vim git tmux input ## Install essential dotfiles (bash, vim, git, tmux, input)

.PHONY: help all install bash gdb git input mintty sumatra_pdf tcsh tmux vim vimperator emacs keyboard check backup clean update essential
