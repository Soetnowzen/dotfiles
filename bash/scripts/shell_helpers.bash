#!/bin/bash

function duh() {
	printf "du -h --max-depth=1 %s | sort -hr\n" "$(printf '%q ' "$@")" >&2
	command du -h --max-depth=1 "$@" | sort -hr
}

function psgrep() {
	printf "ps aux | grep -v grep | grep -i %s\n" "$(printf '%q ' "$@")" >&2
	command ps aux | command grep -v grep | command grep -i "$@"
}

function myip() {
	echo "Local IP: $(hostname -I | awk '{print $1}')"
	echo "External IP: $(curl -s ifconfig.me)"
}

function password_gen() {
	local length="${1:-20}"
	local chars='A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?'
	tr -dc "$chars" </dev/urandom | head -c "$length"
	echo
}

function mark() {
	export "MARK_${1}"="$PWD"
	echo "Marked $PWD as $1"
}

function jump() {
	local mark_var="MARK_$1"
	local mark_dir="${!mark_var}"
	if [[ -n "$mark_dir" && -d "$mark_dir" ]]; then
		cd "$mark_dir" || return 1
	else
		echo "Mark $1 not set or directory doesn't exist" >&2
		return 1
	fi
}

function marks() {
	env | grep '^MARK_' | sed 's/^MARK_//' | sort
}

function most_used_cmd() {
	HISTTIMEFORMAT= builtin history \
		| command awk '{CMD[$2]++; count++} END {for (cmd in CMD) printf "%d %.1f %s\n", CMD[cmd], CMD[cmd] / count * 100, cmd}' \
		| command sort -nr \
		| command head -10 \
		| command awk '{printf "%-20s %3d (%.1f%%)\n", $3, $1, $2}'
}

function most_used_cmd_with_args() {
	HISTTIMEFORMAT= builtin history \
		| command awk '{$1=""; print substr($0, 2)}' \
		| command sort \
		| command uniq -c \
		| command sort -nr \
		| command head -10
}

function mcd()
{
	directory="${1}"
	mkdir -p "$directory"
	cd "$directory" || exit
}

function find_files() {
	local pattern="$1"
	shift
	find "${@:-.}" -type f -name "*${pattern}*" 2>/dev/null
}

function my_pylint() {
	local python_version="${1:-3}"
	local python_file="$2"

	if [[ -z "$python_file" ]]; then
		echo "Usage: my_pylint [python_version] <file.py>" >&2
		return 1
	fi

	python"${python_version}" -m pylint "$python_file"
}

function countdown() {
	local seconds="${1:-60}"
	local end_time=$(($(date +%s) + seconds))

	while [[ $end_time -gt $(date +%s) ]]; do
		local remaining=$((end_time - $(date +%s)))
		printf "\r%s" "$(date -u -d @${remaining} +%H:%M:%S)"
		sleep 0.1
	done
	echo -e "\nTime's up!"
}

function stopwatch()
{
	date1=$(date +%s);
	while true; do
		echo -ne "$(date -u --date @$(($(date +%s) - date1)) +%H:%M:%S)\\r";
		sleep 0.1
	done
}