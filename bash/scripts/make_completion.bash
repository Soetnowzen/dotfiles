# make(1) completion                                       -*- shell-script -*-

function _make_complete()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		-f|--file|--makefile)
			COMPREPLY=( $( compgen -f -- "$current" ) )
			return
			;;
		-C|--directory)
			COMPREPLY=( $( compgen -d -- "$current" ) )
			return
			;;
		-j|--jobs)
			COMPREPLY=( $( compgen -W "1 2 4 8 16" -- "$current" ) )
			return
			;;
	esac

	local options="
		-f --file --makefile
		-C --directory
		-j --jobs
		-k --keep-going
		-n --dry-run --just-print --recon
		-s --silent --quiet
		-v --version
		-w --print-directory
		-W --what-if --new-file --assume-new
		-B --always-make
		-d --debug
		-e --environment-overrides
		-i --ignore-errors
		-I --include-dir
		-l --load-average --max-load
		-L --check-symlink-times
		-o --old-file --assume-old
		-p --print-data-base
		-q --question
		-r --no-builtin-rules
		-R --no-builtin-variables
		-S --no-keep-going --stop
		-t --touch
		-T --no-print-directory
		--help
	"

	if [[ $current == -* ]]; then
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Find makefile and extract targets
	local makefile=""
	for file in GNUmakefile makefile Makefile; do
		if [[ -f "$file" ]]; then
			makefile="$file"
			break
		fi
	done

	if [[ -n "$makefile" ]]; then
		local targets=$(grep -E '^[a-zA-Z0-9_.-]+:([^=]|$)' "$makefile" | cut -d: -f1 | sort -u)
		COMPREPLY=( $( compgen -W "$targets" -- "$current" ) )
	fi
}

complete -F _make_complete -o default make
