# fg(1)/bg(1) completion                                   -*- shell-script -*-

function _fg_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	if [[ $current == -* ]]; then
		# fg/bg don't have many options, but let's be complete
		local options="--help"
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Complete job specifications
	local jobs_output=$(jobs 2>/dev/null)
	if [[ -n "$jobs_output" ]]; then
		# Extract job numbers and create %n format
		local job_specs=$(echo "$jobs_output" | sed -n 's/^\[\([0-9]\+\)\].*/\%\1/p')
		# Also add + and - for most recent jobs
		local recent_jobs="%+ %- + -"
		COMPREPLY=( $( compgen -W "$job_specs $recent_jobs" -- "$current" ) )
	fi
}

complete -o default -F _fg_completion fg bg
