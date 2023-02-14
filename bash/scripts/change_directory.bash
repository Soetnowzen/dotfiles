unalias .. 2> /dev/null
unalias ... 2> /dev/null

function ..()
{
	local destination=$1
	if [[ $destination == "" ]]; then
		cd .. || exit
	elif [[ $destination == "/" ]]; then
		cd / || exit
	else
		local new_pwd=$PWD
		local directories=$(pwd | tr '/' '\n' | tac | tr '\n' ' ')
		for directory in $directories; do
			if [[ $destination != $directory ]]; then
				new_pwd+="/.."
			else
				break
			fi
		done
		cd "$new_pwd" || exit
	fi
}

function _change_directory_completion()
{
	if [[ $COMP_CWORD == 1 ]]; then
		directories=$(pwd | tr '/' ' ')
		directories+=' /'
		COMPREPLY=($(compgen -W "$directories" "${COMP_WORDS[1]}"))
	fi
}

complete -F _change_directory_completion ..
