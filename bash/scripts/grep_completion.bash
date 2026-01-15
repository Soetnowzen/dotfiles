# grep(1)/rg(1) completion                              -*- shell-script -*-

function _grep_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		--help|--version|-V)
			return
			;;
		# Options with specific values
		--color|--colour)
			COMPREPLY=( $( compgen -W "auto always never" -- "$current" ) )
			return
			;;
		--engine)
			COMPREPLY=( $( compgen -W "default pcre2 auto" -- "$current" ) )
			return
			;;
		--sort|--sortr)
			COMPREPLY=( $( compgen -W "none path modified accessed created" -- "$current" ) )
			return
			;;
		-t|--type)
			if command -v rg >/dev/null 2>&1; then
				COMPREPLY=( $( compgen -W "agda asm asciidoc awk bash bib c cmake config cpp csharp css csv dart dockerfile elisp elixir erlang fortran go haskell html java js json julia latex less lisp lua make markdown objc ocaml pascal perl php pod protobuf python r rdoc rst ruby rust scala sh sql svg tex txt vhdl vim xml yaml" -- "$current" ) )
			fi
			return
			;;
		# Options that expect arguments - ripgrep
		-A|--after-context|-B|--before-context|-C|--context|--colors|--context-separator|--dfa-size-limit|-E|--encoding|--field-context-separator|--field-match-separator|-f|--file|-g|--glob|--iglob|--ignore-file|-M|--max-columns|-m|--max-count|--max-depth|--max-filesize|--path-separator|--pre|--pre-glob|--regex-size-limit|-e|--regexp|-r|--replace|-j|--threads|--type-add|--type-clear|-T|--type-not)
			return
			;;
		# Options that expect arguments - traditional grep
		--label|--binary-files|--directories|-D|--devices|-d|--exclude|--exclude-from|--exclude-dir|--include|-m|--max-count|-A|--after-context|-B|--before-context|-C|--context|-e|--regexp|-f|--file)
			return
			;;
	esac

	local options=""
	
	# Check if we're actually using ripgrep
	if command -v rg >/dev/null 2>&1; then
		# ripgrep options
		options="
			-A --after-context
			--auto-hybrid-regex
			-B --before-context
			--binary
			--block-buffered
			-b --byte-offset
			-s --case-sensitive
			--color
			--colors
			--column
			-C --context
			--context-separator
			-c --count
			--count-matches
			--crlf
			--debug
			--dfa-size-limit
			-E --encoding
			--engine
			--field-context-separator
			--field-match-separator
			-f --file
			--files
			-l --files-with-matches
			--files-without-match
			-F --fixed-strings
			-L --follow
			-g --glob
			--glob-case-insensitive
			-h --help
			--heading
			-. --hidden
			--iglob
			-i --ignore-case
			--ignore-file
			--ignore-file-case-insensitive
			--include-zero
			-v --invert-match
			--json
			--line-buffered
			-n --line-number
			-x --line-regexp
			-M --max-columns
			--max-columns-preview
			-m --max-count
			--max-depth
			--max-filesize
			--mmap
			-U --multiline
			--multiline-dotall
			--no-config
			-I --no-filename
			--no-heading
			--no-ignore
			--no-ignore-dot
			--no-ignore-exclude
			--no-ignore-files
			--no-ignore-global
			--no-ignore-messages
			--no-ignore-parent
			--no-ignore-vcs
			-N --no-line-number
			--no-messages
			--no-mmap
			--no-pcre2-unicode
			--no-require-git
			--no-unicode
			-0 --null
			--null-data
			--one-file-system
			-o --only-matching
			--passthru
			--path-separator
			-P --pcre2
			--pcre2-version
			--pre
			--pre-glob
			-p --pretty
			-q --quiet
			--regex-size-limit
			-e --regexp
			-r --replace
			-z --search-zip
			-S --smart-case
			--sort
			--sortr
			--stats
			-a --text
			-j --threads
			--trim
			-t --type
			--type-add
			--type-clear
			--type-list
			-T --type-not
			-u --unrestricted
			-V --version
			--vimgrep
			-H --with-filename
			-w --word-regexp
		"
	else
		# Regular grep options
		options="
			-E --extended-regexp
			-F --fixed-strings
			-G --basic-regexp
			-P --perl-regexp
			-e --regexp
			-f --file
			-i --ignore-case
			--no-ignore-case
			-w --word-regexp
			-x --line-regexp
			-z --null-data
			-s --no-messages
			-v --invert-match
			-V --version
			--help
			-m --max-count
			-b --byte-offset
			-n --line-number
			-H --with-filename
			-h --no-filename
			--label
			-o --only-matching
			-q --quiet
			--silent
			-a --text
			--binary-files
			-I
			-d --directories
			-D --devices
			-r --recursive
			-R --dereference-recursive
			--include
			--exclude
			--exclude-from
			--exclude-dir
			-L --files-without-match
			-l --files-with-matches
			-c --count
			-T --initial-tab
			-Z --null
			-B --before-context
			-A --after-context
			-C --context
			--color
			--colour
			-U --binary
			-u --unix-byte-offsets
		"
	fi

	if [[ $current == -* ]]; then
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Default to filename completion for non-option arguments
	COMPREPLY=( $( compgen -f -- "$current" ) )
}

complete -o default -F _grep_completion grep grepi greprin grepbb grepc