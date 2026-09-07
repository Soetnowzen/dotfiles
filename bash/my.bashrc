#!/bin/bash

# set -o vi
# Set up vi mode indicators with custom styling
bind 'set vi-ins-mode-string "\1\e[6;30;42m\2 INS \1\e[0m\2"'
bind 'set vi-cmd-mode-string "\1\e[6;30;41m\2 CMD \1\e[0m\2"'
bind 'set show-mode-in-prompt on'
# ctrl-k (until end), ctrl-u (until begin), ctrl-w (backward), ctrl-y (paste) - cutting and pasting text in the command line
# ctrl-r search_term to search for previous command.
# !! to perform last command in this position

if [ -r ~/.bashrc.work ]; then
	. ~/.bashrc.work
fi

dotfiles_dir="$HOME/dotfiles/bash"
source "$dotfiles_dir/scripts/change_directory.bash"
source "$dotfiles_dir/scripts/cat_completion.bash"
source "$dotfiles_dir/scripts/chmod_completion.bash"
source "$dotfiles_dir/scripts/chown_completion.bash"
source "$dotfiles_dir/scripts/extract.bash"
source "$dotfiles_dir/scripts/find_completion.bash"
source "$dotfiles_dir/scripts/git_completion.bash"
source "$dotfiles_dir/scripts/grep_completion.bash"
source "$dotfiles_dir/scripts/kill_completion.bash"
source "$dotfiles_dir/scripts/ls_completion.bash"
source "$dotfiles_dir/scripts/make_completion.bash"
# source "$dotfiles_dir/scripts/mount_completion.bash"
source "$dotfiles_dir/scripts/output_color.bash"
source "$dotfiles_dir/scripts/ssh_completion.bash"
source "$dotfiles_dir/scripts/tmux-session-saver.bash"
# source "$dotfiles_dir/scripts/unmount_completion.bash"
source "$dotfiles_dir/scripts/fg_completion.bash"
source "$dotfiles_dir/scripts/watch_files.sh"
source "$dotfiles_dir/scripts/worktree_navigation.bash"
source "$dotfiles_dir/scripts/yarn_completion.bash"
source "$dotfiles_dir/scripts/docker_completion.bash"
source "$dotfiles_dir/scripts/copilot.bash"

# Sourced once; the prompt is then rendered by a function call instead of
# fork+exec'ing the script on every prompt.
source "$dotfiles_dir/configurations/prompt.bash"

# Array form, so tools that append to PROMPT_COMMAND (direnv, conda, atuin,
# VS Code shell integration, ...) compose with the prompt instead of one
# silently overwriting the other.
PROMPT_COMMAND=(_prompt)
CYAN="$(tput setaf 6)"
RESET="$(tput sgr0)"
# Stamp the command start time with zero forks: the arithmetic inside the array
# subscript performs the assignment, and ${__PROMPT_NULL[...]} expands to "".
PS0='${__PROMPT_NULL[__PROMPT_T0=${EPOCHREALTIME//[!0-9]/}]}'
# PS0='\[\ePtmux;\e\e[2 q\e\\\]'

# Set to 0 to stop re-reading the whole history file on every prompt; history is
# then only appended (much cheaper, but no live sharing between terminals).
: "${BASH_SHARE_HISTORY:=1}"
# Commands faster than this are not worth timing; showing "0ms" on every prompt
# only drains the number of its signal. Set to 0 to always show it.
: "${PROMPT_MIN_TIME_MS:=500}"
# Keep $COLUMNS current so the prompt can size the path against the window.
shopt -s checkwinsize

function _prompt()
{
	# This needs to be first
	local EXIT="$?"

	# Elapsed time of the command that just finished. Builtins only.
	# Short commands render no timer segment at all.
	if [[ -n ${__PROMPT_T0:-} ]]; then
		local __now=${EPOCHREALTIME//[!0-9]/}
		local __elapsed_us=$((__now - __PROMPT_T0))
		unset -v __PROMPT_T0
		__PROMPT_TIMER=""
		if ((__elapsed_us / 1000 >= PROMPT_MIN_TIME_MS)); then
			local __pretty
			__format_duration __pretty "$__elapsed_us"
			__PROMPT_TIMER="\\[${CYAN}\\]⏱${__pretty}\\[${RESET}\\] "
		fi
	else
		# No command ran (bare Enter); do not leave a stale duration behind.
		__PROMPT_TIMER=""
	fi

	# After each command, save (and optionally reload) history
	history -a
	if [[ $BASH_SHARE_HISTORY == 1 ]]; then
		history -c
		history -r
	fi

	# Directory stack size, straight from the shell's own array
	local dirs_count=${#DIRSTACK[@]}

	# Count stopped and running jobs in one pass (one subshell instead of five)
	local stopped_jobs=0 running_jobs=0 jobs_output line
	jobs_output=$(jobs 2>/dev/null)
	if [[ -n $jobs_output ]]; then
		while IFS= read -r line; do
			case $line in
			*Stopped*) ((stopped_jobs++)) ;;
			*Running*) ((running_jobs++)) ;;
			esac
		done <<< "$jobs_output"
	fi

	__prompt_command "$EXIT" "$dirs_count" "$stopped_jobs" "$running_jobs"
	PS1="${__PROMPT_OUT}"$'\n'" ${__PROMPT_TIMER}${__PROMPT_SIGIL} "
	return $EXIT
}

# "#" for root, "$" otherwise - the usual convention.
if ((UID == 0)); then
	__PROMPT_SIGIL="#"
else
	__PROMPT_SIGIL="\$"
fi

# Format microseconds into "1h 2m 3s 4ms" and store it in the named variable.
function __format_duration()
{
	local __var=$1
	local total_ms=$(($2 / 1000))

	local days=$((total_ms / 86400000))
	local hours=$((total_ms % 86400000 / 3600000))
	local minutes=$((total_ms % 3600000 / 60000))
	local seconds=$((total_ms % 60000 / 1000))
	local milliseconds=$((total_ms % 1000))

	local readable_time=""
	((days > 0)) && readable_time+="${days}d "
	((hours > 0)) && readable_time+="${hours}h "
	((minutes > 0)) && readable_time+="${minutes}m "
	if ((seconds > 0 || minutes > 0 || hours > 0 || days > 0)); then
		readable_time+="${seconds}s "
	fi
	readable_time+="${milliseconds}ms"
	printf -v "$__var" '%s' "$readable_time"
}

function display_time()
{
	# Input is microseconds as an integer
	local total_us=$1
	local total_ms=$((total_us / 1000))

	local days=$((total_ms / 86400000))
	local hours=$((total_ms % 86400000 / 3600000))
	local minutes=$((total_ms % 3600000 / 60000))
	local seconds=$((total_ms % 60000 / 1000))
	local milliseconds=$((total_ms % 1000))

	local readable_time=""
	((days > 0)) && readable_time+="${days}d "
	((hours > 0)) && readable_time+="${hours}h "
	((minutes > 0)) && readable_time+="${minutes}m "
	# Always show seconds if we have any time units above, or if seconds > 0
	if ((seconds > 0 || minutes > 0 || hours > 0 || days > 0)); then
		readable_time+="${seconds}s "
	fi
	# Always show milliseconds
	readable_time+="${milliseconds}ms"
	printf '%s' "$readable_time"
}

# Command timing lives entirely in shell variables now (see PS0 and _prompt);
# no /dev/shm file, no exit trap, no subshell per prompt redraw.
ROOTPID=$BASHPID

# Shell options
# {
# Enable direxpand (so that env variables are expended when tab completing)
shopt -s direxpand
shopt -s expand_aliases

# Case insensitive completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

# Improved cd behavior
shopt -s autocd  # Just type directory name to cd into it
shopt -s cdspell # Auto-correct minor spelling errors in cd

# disable histexpand (the !123 syntax)
set +o histexpand
# }

# Variables
#{
EDITOR=vim
export EDITOR
# }

# tmux history
#{

# Increase history size significantly
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTFILE=~/.bash_history_extended
# Add timestamp to history
export HISTTIMEFORMAT='%F %T '
# Ignore duplicate commands and commands starting with space
export HISTCONTROL=ignoreboth:erasedups

# append history enteies
shopt -s histappend
# }

# Aliases
# {
source "$dotfiles_dir/scripts/command_wrappers.bash"
source "$dotfiles_dir/scripts/git_helpers.bash"
source "$dotfiles_dir/scripts/docker_helpers.bash"
source "$dotfiles_dir/scripts/shell_helpers.bash"
source "$dotfiles_dir/scripts/terminal_helpers.bash"
source "$dotfiles_dir/scripts/search_helpers.bash"

alias la='ls -a'
alias ll='la -l'
alias l='ll'
alias l_size='ll -S'
alias :q='exit'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bashr='vim ~/.bashrc'
alias cl='clear &&'
alias d='dirs -v'
alias du_sort="du | sort -nr"
alias ex="emacs --no-window-system"
alias exc="emacsclient -nw -c"
alias f='fg'
alias g='git'
alias g_pr_stash='git stash && git pull --rebase && git stash pop'
alias gitr='vim ~/.gitconfig'
alias gr='cd `git rev-parse --show-toplevel` 2> /dev/null'
alias d='dirs -v'
alias o='popd'
alias p='pushd'
alias pd='pushd'
alias po='popd'
alias popdd='popd >/dev/null'
alias print_path='echo $PATH | tr : "\n"'
alias pushdd="pushd \$PWD > /dev/null"
alias rmrf='rm -rf'
alias tcshr='vim ~/.tcshrc'
alias vimr='vim ~/.vimrc'

# Remove broken links by: "findBrokenLinks | exec rm {} \;"
alias find_broken_links='command find -L . -type l'

# Quick SSH config editing
alias sshconfig='vim ~/.ssh/config'
# }

# Solarized
alias sol.dark='source ~/dotfiles/mintty/sol.dark'
alias sol.light='source ~/dotfiles/mintty/sol.light'

# Auto complete searches when using up and down
bind '"\e[A":history-search-backward' # ]
bind '"\e[B":history-search-forward' # ]
bind '"\e[1;3D": backward-word' ### Alt left ]
bind '"\e[1;3C": forward-word' ### Alt right" ]

# Template for argument parsing - remove if not needed
# function parse_args() {
# 	local PARAMS=""
# 	while (( "$#" )); do
# 		case "$1" in
# 			-f|--flag-with-argument)
# 				FLARG=$2
# 				shift 2
# 				;;
# 			--) # end argument parsing
# 				shift
# 				break
# 				;;
# 			-*|--*=) # unsupported flags
# 				echo "Error: Unsupported flag $1" >&2
# 				return 1
# 				;;
# 			*) # preserve positional arguments
# 				PARAMS="$PARAMS $1"
# 				shift
# 				;;
# 		esac
# 	done
# 	eval set -- "$PARAMS"
# }

# Colors
# {

# ls description
# {
# bd = (BLOCK, BLK)   Block device (buffered) special file
# cd = (CHAR, CHR)    Character device (unbuffered) special file
# di = (DIR)  Directory
# do = (DOOR) [Door][1]
# ex = (EXEC) Executable file (ie. has 'x' set in permissions)
# fi = (FILE) Normal file
# ln = (SYMLINK, LINK, LNK)   Symbolic link. If you set this to ‘target’ instead of a numerical value, the color is as for the file pointed to.
# mi = (MISSING)  Non-existent file pointed to by a symbolic link (visible when you type ls -l)
# no = (NORMAL, NORM) Normal (non-filename) text. Global default, although everything should be something
# or = (ORPHAN)   Symbolic link pointing to an orphaned non-existent file
# ow = (OTHER_WRITABLE)   Directory that is other-writable (o+w) and not sticky
# pi = (FIFO, PIPE)   Named pipe (fifo file)
# sg = (SETGID)   File that is setgid (g+s)
# so = (SOCK) Socket file
# st = (STICKY)   Directory with the sticky bit set (+t) and not other-writable
# su = (SETUID)   File that is setuid (u+s)
# tw = (STICKY_OTHER_WRITABLE)    Directory that is sticky and other-writable (+t,o+w)
# *.extension =   Every file using this extension e.g. *.rpm = files with the ending .rpm
# }
LS_COLORS=$LS_COLORS:'di=0;35:ln=0;36:ex=0;33:pi=0;32:so=0;31:bd=0;37:mi=0;36:cd=1;35:tw=0;30:ow=0;34:'
export LS_COLORS

GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32'
export GCC_COLORS
# }

# export DISPLAY=:0.0

# Magento
# {
MAGENTO_PATH="/var/www/html/magento-trial"
alias mage_root="cd \${MAGENTO_PATH}"
alias mage_theme="mage_root && cd app/design/frontend/Venustheme/"
alias mage_module="mage_root && cd app/code/Ves"
alias mage_build="\${MAGENTO_PATH}/bin/magento setup:upgrade --keep-generated"
alias mage_static="\${MAGENTO_PATH}/bin/magento setup:static-content:deploy en_US sv_SE"
alias mage_clear_var="rm -rf \${MAGENTO_PATH}/var/* && cp \${MAGENTO_PATH}/.htaccess-var \${MAGENTO_PATH}/var/.htaccess"
# */
# }

# Solr
# {
SOLR_PATH="${HOME}/lucene-solr/solr"
alias solar_start="\${SOLR_PATH}/bin/solr start"
alias solar_stop="\${SOLR_PATH}/bin/solr stop"
# }

# Variables
# export DISPLAY=localhost:0.0

# Aliases for convenience
alias gcl='git-clone'
alias gclone='git-clone'
export PATH="$HOME/.local/bin:$PATH"
