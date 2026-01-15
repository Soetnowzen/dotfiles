# chmod(1) completion                                      -*- shell-script -*-

function _chmod_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		--help|--version)
			return
			;;
		--reference)
			COMPREPLY=( $( compgen -f -- "$current" ) )
			return
			;;
	esac

	# Handle options first
	if [[ $current == -* ]]; then
		local options="
			--help
			--version
			--reference
			-c --changes
			-f --silent --quiet
			-v --verbose
			--no-preserve-root
			--preserve-root
			-R --recursive
		"
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Handle symbolic permissions
	if [[ $current =~ ^[ugoa]*[+-=][rwxXst]*$ || $current =~ ^[ugoa]*[+-=]?$ ]]; then
		local permissions=""
		
		# If current ends with +, -, or = (operators), complete with permission letters
		if [[ $current =~ [+-=]$ ]]; then
			local base="$current"
			permissions="
				${base}r
				${base}w  
				${base}x
				${base}X
				${base}s
				${base}t
				${base}rw
				${base}rx
				${base}wx
				${base}rwx
			"
		# If current has user/group but no operator, complete with operators
		elif [[ $current =~ ^[ugoa]+$ ]]; then
			permissions="
				${current}+
				${current}-
				${current}=
			"
		# If current is empty or partial, suggest common symbolic patterns
		else
			permissions="
				+x
				+r
				+w
				+rw
				+rwx
				u+
				g+
				o+
				a+
				u+x
				g+x
				o+x
				u+r
				g+r
				o+r
				u+w
				g+w
				o+w
				u+rw
				g+rw
				o+rw
				u+rwx
				g+rwx
				o+rwx
				u=
				g=
				o=
				a=
				u-
				g-
				o-
				a-
			"
		fi
		
		COMPREPLY=( $( compgen -W "$permissions" -- "$current" ) )
		return
	fi
	
	# Handle octal permissions
	if [[ $current =~ ^[0-7]*$ && ${#current} -le 4 ]]; then
		local octals=""
		case ${#current} in
			0|1) octals="0 1 2 3 4 5 6 7" ;;
			2|3) octals="0 1 2 3 4 5 6 7" ;;
		esac
		
		# Add common octal patterns
		local common_octals="644 755 664 775 600 700 666 777"
		COMPREPLY=( $( compgen -W "$octals $common_octals" -- "$current" ) )
		return
	fi

	# Default to filename completion for file arguments
	COMPREPLY=( $( compgen -f -- "$current" ) )
}

complete -o default -F _chmod_completion chmod