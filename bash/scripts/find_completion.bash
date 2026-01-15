# find(1)/fd(1) completion                               -*- shell-script -*-

function _find_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		--help|--version|-V)
			return
			;;
		# fd-specific options that expect specific values
		-c|--color)
			COMPREPLY=( $( compgen -W "auto always never" -- "$current" ) )
			return
			;;
		-t|--type)
			COMPREPLY=( $( compgen -W "f d l s p b c" -- "$current" ) )
			return
			;;
		# fd-specific options that expect arguments
		-d|--max-depth|--min-depth|--max-results|-j|--threads|-x|--exec|-X|--exec-batch|--batch-size|-E|--exclude|-e|--extension|--changed-within|--changed-before|-o|--owner|-S|--size|--ignore-file|--search-path)
			return
			;;
		# Traditional find options that expect specific values
		-type|-xtype)
			COMPREPLY=( $( compgen -W "b c d p f l s" -- "$current" ) )
			return
			;;
		-regextype)
			COMPREPLY=( $( compgen -W "emacs posix-awk posix-basic posix-egrep posix-extended" -- "$current" ) )
			return
			;;
		# Traditional find options that expect arguments
		-maxdepth|-mindepth|-newer|-anewer|-cnewer|-fls|-fprint|-fprint0|-fprintf|-name|-iname|-lname|-ilname|-wholename|-iwholename|-samefile|-fstype|-gid|-group|-uid|-user|-exec|-execdir|-ok|-okdir|-amin|-atime|-cmin|-ctime|-lname|-wholename|-iwholename|-lwholename|-ilwholename|-inum|-path|-ipath|-regex|-iregex|-links|-perm|-size|-used|-printf|-context)
			return
			;;
	esac

	local options=""
	
	# Check if we're actually using fd/fdfind
	if command -v fdfind >/dev/null 2>&1; then
		# fd/fdfind options
		options="
			-H --hidden
			-I --no-ignore
			--no-ignore-vcs
			--no-ignore-global
			--no-require-git
			-u --unrestricted
			-s --case-sensitive
			-i --ignore-case
			-g --glob
			-r --regex
			-F --fixed-strings
			-a --absolute-path
			-l --list-details
			-L --follow
			-p --full-path
			-d --max-depth
			--min-depth
			--max-results
			-1
			-q --quiet
			--has-results
			-j --threads
			-x --exec
			-X --exec-batch
			--batch-size
			-E --exclude
			-e --extension
			-t --type
			-c --color
			--changed-within
			--changed-before
			-o --owner
			-S --size
			--ignore-file
			-0 --print0
			--search-path
			--strip-cwd-prefix
			--one-file-system
			--base-directory
			--path-separator
			--gen-completions
			-h --help
			-V --version
		"
	else
		# Traditional find options
		options="
			-H -L -P
			-D
			-O
			-daystart
			-depth
			-follow
			-help
			-ignore_readdir_race
			-maxdepth
			-mindepth
			-mount
			-noignore_readdir_race
			-noleaf
			-regextype
			-version
			-warn
			-nowarn
			-xdev
			-amin
			-anewer
			-atime
			-cmin
			-cnewer
			-ctime
			-empty
			-executable
			-false
			-fstype
			-gid
			-group
			-ilname
			-iname
			-inum
			-ipath
			-iregex
			-iwholename
			-links
			-lname
			-mmin
			-mtime
			-name
			-newer
			-nogroup
			-nouser
			-path
			-perm
			-readable
			-regex
			-samefile
			-size
			-true
			-type
			-uid
			-used
			-user
			-wholename
			-writable
			-xtype
			-context
			-delete
			-exec
			-execdir
			-fls
			-fprint
			-fprint0
			-fprintf
			-ls
			-ok
			-okdir
			-print
			-print0
			-printf
			-prune
			-quit
		"
	fi

	if [[ $current == -* ]]; then
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Default to directory completion for non-option arguments
	COMPREPLY=( $( compgen -d -- "$current" ) )
}

complete -o default -F _find_completion find ff fi_reg find_broken_links
