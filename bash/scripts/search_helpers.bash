#!/bin/bash

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

function search_and_replace() {
	local old_phrase="$1"
	local new_phrase="$2"

	if [[ -z "$old_phrase" || -z "$new_phrase" ]]; then
		echo "Usage: search_and_replace <old_phrase> <new_phrase>" >&2
		return 1
	fi

	local files
	files=$(grep -ril "$old_phrase" . 2>/dev/null)

	if [[ -z "$files" ]]; then
		echo "No files found containing '$old_phrase'"
		return 0
	fi

	echo "Files to be modified:"
	echo "$files"
	read -p "Continue? (y/N): " -n 1 -r
	echo

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "$files" | xargs sed -i "s/$old_phrase/$new_phrase/g"
		echo "Replacement complete!"
	else
		echo "Operation cancelled."
	fi
}