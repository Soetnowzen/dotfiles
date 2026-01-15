# chown(1) completion                                      -*- shell-script -*-

function _chown_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		--help|--version)
			return
			;;
		--reference|--from)
			COMPREPLY=( $( compgen -f -- "$current" ) )
			return
			;;
	esac

	local options="
		--help
		--version
		--reference
		--from
		-c --changes
		-f --silent --quiet
		-v --verbose
		--dereference
		-h --no-dereference
		--no-preserve-root
		--preserve-root
		-R --recursive
		-H -L -P
	"

	if [[ $current == -* ]]; then
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Handle user:group completion
	if [[ $current == *:* ]]; then
		# Complete group after colon (user:group pattern)
		local user_part="${current%:*}:"
		local group_part="${current##*:}"
		local groups=($(getent group | cut -d: -f1))

		# Build completions with user: prefix
		local group_completions=()
		for group in "${groups[@]}"; do
			if [[ "$group" == "$group_part"* ]]; then
				group_completions+=("${user_part}${group}")
			fi
		done
		COMPREPLY=("${group_completions[@]}")
	elif [[ $current == :* ]]; then
		# Handle case where user typed "chown username :" (with space)
		# Complete group after standalone colon
		local group_part="${current#:}"
		local groups=($(getent group | cut -d: -f1))

		local group_completions=()
		for group in "${groups[@]}"; do
			if [[ "$group" == "$group_part"* ]]; then
				group_completions+=("${group}")
			fi
		done
		COMPREPLY=("${group_completions[@]}")
	else
		# Complete users
		local users=($(getent passwd | cut -d: -f1))
		COMPREPLY=( $( compgen -W "${users[*]}" -- "$current" ) )

		# If we have exactly one user match and current doesn't end with :, suggest user: for user:group syntax
		if [[ ${#COMPREPLY[@]} -eq 1 && "${COMPREPLY[0]}" == "$current" && "$current" != *: ]]; then
			COMPREPLY+=("${current}:")
		fi
	fi
}

complete -o default -F _chown_completion chown

