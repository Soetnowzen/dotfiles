#!/bin/bash

function _fg_completion()
{
	if [[ $COMP_CWORD -eq 1 ]]; then
		JOBS=$(jobs -l | sed "s/\[\(.\+\)\]\([+-]\)\?\s\+[0-9]\+\s\+Stopped\s\+\([A-z\/\.*{},]\+\)\s\*\((wd:.\+)\)\?/\1\2:\3/gI")
		results="+ - "
		for job in $JOBS; do
			echo "job = $job"
			if [[ "$job" != "Host" ]]; then
				results+="$job "
			fi
		done
		COMPREPLY=($(compgen -W "$results" "${COMP_WORDS[1]}"))
	fi
}

complete -F _fg_completion fg
