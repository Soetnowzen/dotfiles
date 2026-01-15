# kill(1) completion                                       -*- shell-script -*-

function _kill_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		-s|--signal)
			# Complete signal names and numbers
			local signals="HUP INT QUIT ILL TRAP ABRT BUS FPE KILL USR1 SEGV USR2 PIPE ALRM TERM STKFLT CHLD CONT STOP TSTP TTIN TTOU URG XCPU XFSZ VTALRM PROF WINCH POLL PWR SYS"
			local signal_numbers="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"
			COMPREPLY=( $( compgen -W "$signals $signal_numbers" -- "$current" ) )
			return
			;;
		-l|--list)
			return
			;;
	esac

	local options="
		-s --signal
		-l --list
		-L --table
		-a --all
		-p --pid
		-q --queue
		--verbose
		--help
		--version
	"

	if [[ $current == -* ]]; then
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Complete process IDs and job specifications
	local pids=$(ps -eo pid --no-headers | tr -d ' ')
	local jobs=$(jobs -p 2>/dev/null)
	local job_specs=$(jobs 2>/dev/null | sed -n 's/^\[\([0-9]\+\)\].*/\%\1/p')
	
	COMPREPLY=( $( compgen -W "$pids $jobs $job_specs" -- "$current" ) )
}

complete -o default -F _kill_completion kill killall pkill