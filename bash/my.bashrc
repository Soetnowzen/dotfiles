#!/bin/bash

# set -o vi
# ctrl-k (until end), ctrl-u (until begin), ctrl-w (backward), ctrl-y (paste) - cutting and pasting text in the command line
# ctrl-r search_term to search for previous command.
# !! to perform last command in this position

if [ -r ~/.bashrc.work ]; then
	. ~/.bashrc.work
fi

dotfiles_dir="$HOME/dotfiles/bash"
source "$dotfiles_dir/scripts/change_directory.bash"
source "$dotfiles_dir/scripts/chmod_completion.bash"
source "$dotfiles_dir/scripts/chown_completion.bash"
source "$dotfiles_dir/scripts/extract.bash"
# source "$dotfiles_dir/scripts/find_completion.bash"
source "$dotfiles_dir/scripts/git_completion.bash"
source "$dotfiles_dir/scripts/kill_completion.bash"
source "$dotfiles_dir/scripts/make_completion.bash"
# source "$dotfiles_dir/scripts/mount_completion.bash"
source "$dotfiles_dir/scripts/output_color.bash"
source "$dotfiles_dir/scripts/ssh_completion.bash"
source "$dotfiles_dir/scripts/tmux-session-saver.bash"
# source "$dotfiles_dir/scripts/unmount_completion.bash"
# source "$dotfiles_dir/scripts/fg_completion.bash"
source "$dotfiles_dir/scripts/watch_files.sh"

PROMPT_COMMAND=_prompt
CYAN="$(tput setaf 6)"
RESET="$(tput sgr0)"
PS1="| $CYAN"'Execution time $(bash_get_stop_time $ROOTPID)'"$RESET"'\n'
PS1="$PS1"'\$ '
PS0='$(bash_get_start_time $ROOTPID)'
# PS0='$(bash_get_start_time $ROOTPID) $ROOTPID experiments \[\033[00m\]\n'
# PS0='\[\ePtmux;\e\e[2 q\e\\\]'

function _prompt()
{
	# This needs to be first
	local EXIT="$?"
	# After each command, save and reload history
	history -a
	history -c
	history -r
	local dirs_count
	dirs_count=$(dirs -v 2> /dev/null | wc -l)
	local jobs_count
	jobs_count=$(jobs -l 2> /dev/null | wc -l)
	"$dotfiles_dir/configurations/prompt.bash" "$EXIT" "$dirs_count" "$jobs_count"
	return $EXIT
}

function display_time()
{
	local time=$1
	local miliseconds
	miliseconds=$(echo "$time / 1 % 1000" | bc)
	local days
	days=$(echo "$time / 60 / 60 / 24 / 1000" | bc)
	local hours
	hours=$(echo "$time / 60 / 60 / 1000 % 24" | bc)
	local minutes
	minutes=$(echo "$time / 60 / 1000 % 60" | bc)
	local seconds
	seconds=$(echo "$time / 1000 % 60" | bc)
	local readable_time=""
	(( days > 0 )) && readable_time+="$days days "
	(( hours > 0 )) && readable_time+="$hours hours "
	(( minutes > 0 )) && readable_time+="$minutes minutes "
	(( seconds > 0 )) && readable_time+="$seconds seconds "
	(( days > 0 || hours > 0 || minutes > 0 || seconds > 0 )) && readable_time+='and '
	readable_time+="$miliseconds ms"
	echo "$readable_time"
}

function bash_get_start_time()
{
	# places the epoch time in ns into shared memory
	date +%s.%N >"/dev/shm/${USER}.bashtime.${1}"
}

function bash_get_stop_time()
{
	# reads stored epoch time and subtracts from current
	local end_time
	end_time=$(date +%s.%N)
	local start_time
	start_time="$(cat "/dev/shm/${USER}.bashtime.${1}")"

	local miliseconds
	miliseconds=$(echo "($end_time - $start_time)*1000" | bc)
	display_time "$miliseconds"
}

ROOTPID=$BASHPID
bash_get_start_time $ROOTPID

function run_on_exit()
{
	rm -I "/dev/shm/${USER}.bashtime.${ROOTPID}"
}

trap run_on_exit EXIT

# Shell options
# {
# Enable direxpand (so that env variables are expended when tab completing)
shopt -s direxpand
shopt -s expand_aliases
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
# avoid duplicates
export HISTCONTROL=ignoredups:erasedups

# append history enteies
shopt -s histappend
# }

# Aliases
# {
alias ls='ls -h -F --color --group-directories-first'
alias la='ls -A'
alias ll='la -l'
alias l='ll'
alias l_size='ll -S'
alias :q='exit'
alias apt-get='sudo apt-get'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bashr='vim ~/.bashrc'
alias c='cat -nv'
alias clr='clear'
alias d='dirs -v'
alias df="df -h"
alias docker_stop_all='docker stop $(docker ps -q)'
alias du_sort="du | sort -nr"
alias ex="emacs --no-window-system"
alias exc="emacsclient -nw -c"
alias f='fg'
alias ff='find . -type f -iname'
alias fi_reg="find . -type f -regex"
alias g='git'
alias g_pr_stash='git stash && git pull --rebase && git stash pop'
alias gitr='vim ~/.gitconfig'
alias gr='cd `git rev-parse --show-toplevel` 2> /dev/null'
alias grep='grep --color'
alias grepbb='grep -Rin --color --include=*.bb'
alias grepc='grep -Rin --color --include=*.{cc,c,h,hh}'
alias grepdir="grep '[^\\/]*$'"
alias grepi='grep --color -i'
alias grepout="grep -i 'err\\w\\+\\|fail\\w\\+\\|undefined\\|\\w\\+\\.\\(cc\\|h\\):[0-9]\\+\\|$'"
alias greprin='grep --color -Rin'
alias h='history'
alias j='jobs -l'
alias less='less -r'
alias mkdir='mkdir -pv'
alias mount='mount | column -t'
alias o='popd'
alias p='pushd'
alias password_gen='apg -m 10 -M SNCL'
alias pd='pushd'
alias po='popd'
alias popdd='popd >/dev/null'
alias print_path='echo $PATH | tr : "\n"'
alias psu='ps u --forest'
alias pushdd="pushd \$PWD > /dev/null"
alias rm='rm -I'
alias rmrf='rm -rf'
alias t='tree'
alias tcshr='vim ~/.tcshrc'
alias tm='tmux attach || tmux new'
alias v-split='vim -o'
alias v-tsplit='vim -p'
alias v-vsplit='vim -O'
alias v='vim -O'
alias vd='vimdiff'
alias vimr='vim ~/.vimrc'
alias vs='vim -o'
alias vt='vim -p'
alias vv='vim -O'
alias wget='wget -c'

# Remove broken links by: "findBrokenLinks | exec rm {} \;"
alias find_broken_links='find -L . -type l'

if [[ $UID != 0 ]]; then
	alias reboot='sudo reboot'
	alias update='sudo apt-get -y update && sudo apt-get -y upgrade'
fi
# }

function cdd()
{
	# Not working yet.
	local directory
	directory="$1"
	cd "~$1"
}

function most_used_cmd()
{
	# history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr
	# history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl
	history | tr -s ' ' | cut -d ' ' -f3 | sort | uniq -c | sort -n | tail | perl -lane 'print $F[1], "\t", $F[0], " ", "▄" x ($F[0] / 12)'
}

function most_used_cmd_arguments()
{
	history | tr -s ' ' | cut -d ' ' -f3,4,5,6,7,8,9,10,11 | sort | uniq -c | sort -n # | perl -lane 'print $F[1], "\t", $F[0], " ", "▄" x ($F[0] / 12)'
}

function mcd()
{
	directory="${1}"
	mkdir -p "$directory"
	cd "$directory" || exit
}

function fi_()
{
	arguments="${*}"
	(find "${arguments}" | grep '[^\/]*$')
}

# Solarized
alias sol.dark='source ~/dotfiles/mintty/sol.dark'
alias sol.light='source ~/dotfiles/mintty/sol.light'

# Auto complete searches when using up and down
bind '"\e[A":history-search-backward' # ]
bind '"\e[B":history-search-forward' # ]
bind '"\e[1;3D": backward-word' ### Alt left ]
bind '"\e[1;3C": forward-word' ### Alt right" ]

function my_pylint()
{
	VERSION="${1}"
	PYTHON_FILE="${2}"
	MY_PYLINT="python${VERSION} -m pylint $PYTHON_FILE"
	eval "$MY_PYLINT"
}

function tail_color()
{
	local file RED GREEN YELLOW MAGENTA WHITE RESET
	# BLUE CYAN ORANGE VIOLET
	file="${1}"
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	MAGENTA="$(tput setaf 5)"
	CYAN="$(tput setaf 6)"
	WHITE="$(tput setaf 7)"
	# ORANGE="$(tput setaf 9)"
	# VIOLET="$(tput setaf 13)"
	RESET="$(tput sgr0)"
	tail "$file" | sed "s/\(\<fail\w\+\|\<err\w\+\)/$RED\1$RESET/gI;
	s/\(\<warn\w\+\)/$YELLOW\1$RESET/gI;
	s/\(\<info\w\+\)/$WHITE\1$RESET/gI;
	s/\(\<ok\w\+\|\<done\>\|\<pass\w\+\)/$GREEN\1$RESET/gI;
	s/\(\<makemake\>\|\<mkmk\>\)/$MAGENTA\1$RESET/gI;
	s/\(\<true\>\|\<false\>\)/$CYAN\1$RESET/gI;
	s/\(\<\w\+.\w\+\>:[[:digit:]]\+\)/$BLUE\1$RESET/gI"
}

function tailf_color()
{
	local file RED GREEN YELLOW MAGENTA WHITE RESET
	# BLUE CYAN ORANGE VIOLET
	file="${1}"
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	MAGENTA="$(tput setaf 5)"
	CYAN="$(tput setaf 6)"
	WHITE="$(tput setaf 7)"
	# ORANGE="$(tput setaf 9)"
	# VIOLET="$(tput setaf 13)"
	RESET="$(tput sgr0)"
	tail -f "$file" | sed "s/\(\<fail\w\+\|\<err\w\+\)/$RED\1$RESET/gI;
	s/\(\<warn\w\+\)/$YELLOW\1$RESET/gI;
	s/\(\<info\w\+\)/$WHITE\1$RESET/gI;
	s/\(\<ok\w\+\|\<done\>\|\<pass\w\+\)/$GREEN\1$RESET/gI;
	s/\(\<makemake\>\|\<mkmk\>\)/$MAGENTA\1$RESET/gI;
	s/\(\<true\>\|\<false\>\)/$CYAN\1$RESET/gI;
	s/\(\<\w\+.\w\+\>:[[:digit:]]\+\)/$BLUE\1$RESET/gI"
}

function testing_flags()
{
	local PARAMS=""

	while (( "$#" )); do
		case "$1" in
			-f|--flag-with-argument)
				FLARG=$2
				shift 2
				;;
			--) # end argument parsing
				shift
				break
				;;
			-*|--*=) # unsupported flags
				echo "Error: Unsupported flag $1" >&2
				;;
			*) # preserve positional arguments
				PARAMS="$PARAMS $1"
				shift
				;;
		esac
	done

	# set positional arguments in their proper place
	eval set -- "$PARAMS"
}

# Colors
# {

# Color script
function colors_and_formatting()
{
	# Background
	for clbg in {40..47} {100..107} 49 ; do
		# Foreground
		for clfg in {30..37} {90..97} 39 ; do
			# Formatting
			for attr in 0 1 2 4 5 7 ; do
				# Print the result
				echo -en "\\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \\e[0m"
			done
			echo # Newline
		done
	done
}

function 256-colors()
{
	for fgbg in 38 48 ; do # Foreground / Background
		for color in {0..255} ; do # Colors
			# Display the color
			printf "\\e[${fgbg};5;%sm  %3s  \\e[0m" $color $color
			# Display 6 colors per lines
			if [ $(((color + 1) % 6)) == 4 ] ; then
				echo # New line
			fi
		done
		echo # New line
	done
}

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

function countdown()
{
	# countdown 60              60 seconds
	# countdown 60*30           30 minutes
	# countdown $((24*60*60))   1 day
	now=$(date +%s)
	date1=$(${now} + "$1");
	while [ "$date1" -ge "$(date +%s)" ]; do
		echo -ne "$(date -u --date @$((date1 - $(date +%s))) +%H:%M:%S)\\r";
		sleep 0.1
	done
}

function stopwatch()
{
	date1=$(date +%s);
	while true; do
		echo -ne "$(date -u --date @$(($(date +%s) - date1)) +%H:%M:%S)\\r";
		sleep 0.1
	done
}

function git-find()
{
	local word=$1
	local RED="$(tput setaf 1)"
	local GREEN="$(tput setaf 2)"
	local YELLOW="$(tput setaf 3)"
	local BLUE="$(tput setaf 4)"
	local MAGENTA="$(tput setaf 5)"
	local CYAN="$(tput setaf 6)"
	local WHITE="$(tput setaf 7)"
	local GREY="$(tput setaf 9)"
	local VIOLET="$(tput setaf 13)"
	local BLACK="$(tput setaf 16)"
	local BOLD="$(tput bold)"
	local UNDERLINE="$(tput smul)"
	local EXIT_UNDERLINE="$(tput rmul)"
	local RESTORE="$(tput sgr0)"
	for file in $(git show --name-only); do
		ROWS=$(git show -- ":/${file}" 2> /dev/null | gawk 'match($0,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){minus_count=a[1];plus_count=a[2];next};\
			/^(---|\+\+\+|[^-+ ])/{print;next};\
			{line=substr($0,2)};\
			/^-/{print "-" minus_count++ ":" line;next};\
			/^[+]/{print "+" plus_count++ ":" line;next};\
			{print "(" minus_count++ "," plus_count++ "):"line}' | grep -E "^\\+[^\\+]" | grep -i "\\<${word}\\>")
		local EXIT_STATUS="$?"
		if [[ $EXIT_STATUS == 0 ]]; then
			ROW_NUMBERS=$(echo "${ROWS}" | sed -e 's/+\([[:digit:]]\+\):.\+/\1/')
			EXIT_STATUS="$?"
			if [[ $EXIT_STATUS == 0 ]]; then
				for ROW in $ROW_NUMBERS; do
					echo -e "${RED}$file${RESTORE}:${GREEN}$ROW ${RESTORE}contains${CYAN} $1${RESTORE}"
				done
			fi
		fi
	done
}

function find_code()
{
	MATCH="$@"
	grep -lr "$MATCH" ${SRCDIR} | while read file
do
	echo ${file}
	grep -nh -A5 -B5 "@MATCH" "${file}"
done
}

function search_and_replace()
{
	old_phrase=$1
	new_phrase=$2
	# find . -type f -exec sed -i "s/$old_phrase/$new_phrase/g" {} \;
	sed -i "s/$old_phrase/$new_phrase/g" "$(grep -ril $old_phrase . 2> /dev/null)"
}

function git-find()
{
	word=$1
	for file in $(git show --name-only); do
		file="$(git rev-parse --show-toplevel)/$file"
		ROWS=$(git show -- "${file}" | gawk 'match($0,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){minus_count=a[1];plus_count=a[2];next};\
			/^(---|\+\+\+|[^-+ ])/{print;next};\
			{line=substr($0,2)};\
			/^-/{print "-" minus_count++ ":" line;next};\
			/^[+]/{print "+" plus_count++ ":" line;next};\
			{print "(" minus_count++ "," plus_count++ "):"line}' |
				grep -E "^\\+[^\\+]" | grep -i "${word}")
		local EXIT_STATUS="$?"
		if [[ $EXIT_STATUS == 0 ]]; then
			ROW_NUMBERS=$(echo "${ROWS}" | sed -e 's/+\([[:digit:]]\+\):.\+/\1/')
			EXIT_STATUS="$?"
			if [[ $EXIT_STATUS == 0 ]]; then
				for ROW in $ROW_NUMBERS; do
					printf "%s%s%s:%s%s %scontains%s %s%s.\\n" "${RED}" "${file}" "${RESTORE}" "${GREEN}" "${ROW}" "${RESTORE}" "${CYAN}" "${word}" "${RESTORE}"
				done
			fi
		fi


	done
}

# Variables
# export DISPLAY=localhost:0.0
