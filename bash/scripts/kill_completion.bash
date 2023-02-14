# kill(1) completion                                       -*- shell-script -*-

_kill()
{
	local cur prev words cword
	_init_completion || return

	case $prev in
		-s)
			_signals
			return
			;;
		-l)
			return
			;;
	esac

	if [[ $cword -eq 1 && "$cur" == -* ]]; then
		# return list of available signals
		_signals -
		COMPREPLY+=( $( compgen -W "-s -l" -- "$cur" ) )
	else
		# return list of available PIDs
		_pids
	fi
}

# complete -F _kill kill

function _kill_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		-s)
			local -a sigs=( $( compgen -P "$1" -A signal "SIG${cur#$1}" ) )
			COMPREPLY+=( "${sigs[@]/#${1}SIG/${1}}" )
			return
			;;
		-l)
			return
			;;
		-9)
			_get_process_id "$current"
			return
			;;
		-15)
			_get_process_id "$current"
			return
			;;
	esac

	if [[ $COMP_CWORD == 1 ]]; then
		# if [[ $current == -* ]]; then
		local flags='-9 -15 -s -l'
		COMPREPLY+=( $( compgen -W "$flags" -- "$cur" ) )
	fi
}

function _get_process_id()
{
	local current
	current=$1
	# signals=$(ps -u | tr -s ' ' | cut -d ' ' -f2,11,12,13,14)
	signals=$(ps u | tr -s ' ' | cut -d ' ' -f2)
	COMPREPLY+=($(compgen -W "$signals" -- "$current"))
}

complete -F _kill_completion kill

# ex: filetype=sh
