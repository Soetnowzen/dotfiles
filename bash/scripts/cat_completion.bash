# cat(1)/bat(1) completion                              -*- shell-script -*-

function _cat_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		--help|--version)
			return
			;;
		# bat options with specific values
		--color)
			COMPREPLY=( $( compgen -W "auto always never" -- "$current" ) )
			return
			;;
		--paging)
			COMPREPLY=( $( compgen -W "auto always never" -- "$current" ) )
			return
			;;
		--decorations|-d)
			COMPREPLY=( $( compgen -W "auto always never" -- "$current" ) )
			return
			;;
		--wrap)
			COMPREPLY=( $( compgen -W "auto never character" -- "$current" ) )
			return
			;;
		# bat options that expect arguments
		--language|-l|--theme|--tabs|--terminal-width|--pager|--map-syntax|-m|--style|--highlight-line|-H|--line-range|-r|--diff)
			# These bat options expect arguments, let default completion handle it
			return
			;;
	esac

	local options=""
	
	# Check if we're actually using bat/batcat
	if command -v batcat >/dev/null 2>&1; then
		# bat/batcat options
		options="
			-A --show-all
			-p --plain
			-P --paging
			-l --language
			-H --highlight-line
			-r --line-range
			--theme
			--list-themes
			--style
			--color
			--decorations
			-d
			--paging
			--pager
			--tabs
			--wrap
			--terminal-width
			--number
			-n
			--show-nonprinting
			-v
			--squeeze-blank
			-s
			--diff
			--diff-context
			--map-syntax
			-m
			--italic-text
			--help
			-h
			--version
			-V
		"
	else
		# Regular cat options
		options="
			-A --show-all
			-b --number-nonblank  
			-e
			-E --show-ends
			-n --number
			-s --squeeze-blank
			-t
			-T --show-tabs
			-u
			-v --show-nonprinting
			--help
			--version
		"
	fi

	if [[ $current == -* ]]; then
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Default to filename completion for non-option arguments
	COMPREPLY=( $( compgen -f -- "$current" ) )
}

complete -o default -F _cat_completion cat