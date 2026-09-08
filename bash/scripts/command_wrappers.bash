#!/bin/bash

if command -v batcat >/dev/null 2>&1; then
	cat() { printf "batcat --theme=ansi %s\n" "$(printf '%q ' "$@")" >&2; command batcat --theme=ansi "$@"; }
	c() { printf "c %s\n" "$(printf '%q ' "$@")" >&2; command batcat --theme=ansi "$@"; }
	echo "cat -> batcat"
else
	alias cat='command cat'
	c() { printf "c %s\n" "$(printf '%q ' "$@")" >&2; command cat -nv "$@"; }
fi

if command -v fdfind >/dev/null 2>&1; then
	find() { printf "fdfind %s\n" "$(printf '%q ' "$@")" >&2; command fdfind "$@"; }
	echo "find -> fdfind"
else
	alias find='command find'
	alias ff='find . -type f -iname'
	alias fi_reg="find . -type f -regex"
fi

if command -v rg >/dev/null 2>&1; then
	grep() { printf "rg %s\n" "$(printf '%q ' "$@")" >&2; command rg "$@"; }
	echo "grep -> rg"
else
	alias grep='command grep --color'
fi
alias grepbb='grep -Rin --color --include=*.bb'
alias grepc='grep -Rin --color --include=*.{cc,c,h,hh}'
alias grepdir="grep '[^\\/]*$'"
alias grepi='grep --color -i'
alias grepout="grep -i 'err\\w\\+\\|fail\\w\\+\\|undefined\\|\\w\\+\\.\\(cc\\|h\\):[0-9]\\+\\|$'"
alias greprin='grep --color -Rin'

if command -v eza >/dev/null 2>&1; then
	ls() { printf "eza --group-directories-first --color=auto %s\n" "$(printf '%q ' "$@")" >&2; command eza --group-directories-first --color=auto "$@"; }
	alias ls-git='eza --git --group-directories-first --color=auto'
	echo "ls -> eza --group-directories-first --color=auto"
elif command -v exa >/dev/null 2>&1; then
	ls() { printf "exa --group-directories-first --color=auto %s\n" "$(printf '%q ' "$@")" >&2; command exa --group-directories-first --color=auto "$@"; }
	alias ls-git='exa --git --group-directories-first --color=auto'
	echo "ls -> exa --group-directories-first --color=auto"
else
	alias ls='command ls -h -F --color --group-directories-first'
fi

apt-get() { printf "sudo apt-get %s\n" "$(printf '%q ' "$@")" >&2; sudo apt-get "$@"; }
df() { printf "df -h %s\n" "$(printf '%q ' "$@")" >&2; command df -h "$@"; }
h() { printf "history %s\n" "$(printf '%q ' "$@")" >&2; history "$@"; }
j() { printf "jobs -l %s\n" "$(printf '%q ' "$@")" >&2; jobs -l "$@"; }
less() { printf "less -r %s\n" "$(printf '%q ' "$@")" >&2; command less -r "$@"; }
mkdir() { printf "mkdir -pv %s\n" "$(printf '%q ' "$@")" >&2; command mkdir -pv "$@"; }
mount() { printf "mount %s | column -t\n" "$(printf '%q ' "$@")" >&2; command mount "$@" | column -t; }
psu() { printf "ps u --forest %s\n" "$(printf '%q ' "$@")" >&2; command ps u --forest "$@"; }
t() { printf "tree %s\n" "$(printf '%q ' "$@")" >&2; command tree "$@"; }
wget() { printf "wget -c %s\n" "$(printf '%q ' "$@")" >&2; command wget -c "$@"; }

tm() {
	if command tmux has-session 2>/dev/null; then
		printf "tmux attach\n" >&2
	else
		printf "tmux new\n" >&2
		command tmux new-session -d
	fi
	~/dotfiles/tmux/apply-theme.sh
	command tmux attach
}

v-split()  { printf "vim -o %s\n"  "$(printf '%q ' "$@")" >&2; command vim -o "$@"; }
v-tsplit() { printf "vim -p %s\n"  "$(printf '%q ' "$@")" >&2; command vim -p "$@"; }
v-vsplit() { printf "vim -O %s\n"  "$(printf '%q ' "$@")" >&2; command vim -O "$@"; }
v()        { printf "vim -O %s\n"  "$(printf '%q ' "$@")" >&2; command vim -O "$@"; }
vd()       { printf "vimdiff %s\n" "$(printf '%q ' "$@")" >&2; command vimdiff "$@"; }
vs()       { printf "vim -o %s\n"  "$(printf '%q ' "$@")" >&2; command vim -o "$@"; }
vt()       { printf "vim -p %s\n"  "$(printf '%q ' "$@")" >&2; command vim -p "$@"; }
vv()       { printf "vim -O %s\n"  "$(printf '%q ' "$@")" >&2; command vim -O "$@"; }

rm() { printf "rm -I --preserve-root %s\n" "$(printf '%q ' "$@")" >&2; command rm -I --preserve-root "$@"; }
mv() { printf "mv -i %s\n" "$(printf '%q ' "$@")" >&2; command mv -i "$@"; }
cp() { printf "cp -i %s\n" "$(printf '%q ' "$@")" >&2; command cp -i "$@"; }
ln() { printf "ln -i %s\n" "$(printf '%q ' "$@")" >&2; command ln -i "$@"; }

ssha() { printf "ssh -A %s\n" "$(printf '%q ' "$@")" >&2; command ssh -A "$@"; }
sshlist() { printf "ss -t state established '( dport = :22 or sport = :22 )'\n" >&2; command ss -t state established '( dport = :22 or sport = :22 )'; }

if [[ $UID != 0 ]]; then
	reboot() { printf "sudo reboot\n" >&2; sudo reboot; }
	update() { printf "sudo apt-get -y update && sudo apt-get -y upgrade\n" >&2; sudo apt-get -y update && sudo apt-get -y upgrade; }
fi