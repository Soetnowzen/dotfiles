# ls(1)/exa(1) completion                               -*- shell-script -*-

function _ls_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		--help|--version|-v|-\?)
			return
			;;
		--color|--colour|--time-style|--format|--indicator-style|--quoting-style|--sort|--tabsize|-T|-w|--width|--block-size)
			# These options expect arguments, let default completion handle it
			return
			;;
		# exa-specific options that expect arguments
		-s|--sort|-L|--level|-I|--ignore-glob|--time|--time-style)
			return
			;;
	esac

	local options=""
	
	# Check if we're actually using exa
	if command -v exa >/dev/null 2>&1; then
		# exa options
		options="
			-1 --oneline
			-l --long
			-G --grid
			-x --across
			-R --recurse
			-T --tree
			-F --classify
			--color --colour
			--color-scale --colour-scale
			--icons
			--no-icons
			-a --all
			-d --list-dirs
			-L --level
			-r --reverse
			-s --sort
			--group-directories-first
			-D --only-dirs
			-I --ignore-glob
			--git-ignore
			-b --binary
			-B --bytes
			-g --group
			-h --header
			-H --links
			-i --inode
			-m --modified
			-S --blocks
			-t --time
			-u --accessed
			-U --created
			-@ --extended
			--git
			--no-permissions
			--no-filesize
			--no-user
			--no-time
			-? --help
			-v --version
		"
	else
		# Regular ls options
		options="
			-a --all
			-A --almost-all
			--author
			-b --escape
			--block-size
			-B --ignore-backups
			-c
			-C
			--color --colour
			-d --directory
			-D --dired
			-f
			-F --classify
			--file-type
			--format
			--full-time
			-g
			--group-directories-first
			-G --no-group
			-h --human-readable
			--si
			-H --dereference-command-line
			--dereference-command-line-symlink-to-dir
			--hide
			--hyperlink
			--indicator-style
			-i --inode
			-I --ignore
			-k --kibibytes
			-l
			-L --dereference
			-m
			-n --numeric-uid-gid
			-N --literal
			-o
			-p
			-q --hide-control-chars
			--show-control-chars
			-Q --quote-name
			--quoting-style
			-r --reverse
			-R --recursive
			-s --size
			-S
			--sort
			--time
			--time-style
			-t
			-T --tabsize
			-u
			-U
			-v
			-w --width
			-x
			-X
			-Z --context
			-1
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

complete -o default -F _ls_completion ls la ll l