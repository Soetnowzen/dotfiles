function _make_complete()
{
	if [[ $COMP_CWORD == 1 ]]; then
		if [[ -f makefile ]]; then
			local commands
			commands=$(grep '^\w\+:\.*' makefile | sed -e 's/\(.*\):.*/\1/')
			COMPREPLY=($(compgen -W "$commands" "${COMP_WORDS[1]}"))
		fi
	fi
}

complete -F _make_complete -o default make
