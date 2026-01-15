# ssh(1) completion                                        -*- shell-script -*-

function _get_hosts()
{
	local results=""
	if [[ -f ~/.ssh/config ]]; then
		local hosts=$(awk '/^Host / { for (i=2; i<=NF; i++) if ($i !~ /[*?]/) print $i }' ~/.ssh/config)
		for host in $hosts; do
			results+="$host "
		done
	fi
	
	# Also get from known_hosts
	if [[ -f ~/.ssh/known_hosts ]]; then
		local known=$(awk -F'[, ]' '/^[^|#]/ { print $1 }' ~/.ssh/known_hosts | cut -d: -f1 | sort -u)
		for host in $known; do
			if [[ $host != *"*"* && $host != *"["* ]]; then
				results+="$host "
			fi
		done
	fi
	
	echo "$results" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

function _ssh_completion()
{
	local current previous
	current=${COMP_WORDS[COMP_CWORD]}
	previous=${COMP_WORDS[COMP_CWORD-1]}

	case $previous in
		-F)
			COMPREPLY=( $( compgen -f -- "$current" ) )
			return
			;;
		-i)
			COMPREPLY=( $( compgen -f -- "$current" ) )
			return
			;;
		-l|-o|-p|-c|-m|-S)
			return
			;;
	esac

	local options="
		-1 -2 -4 -6
		-A -a
		-B
		-b
		-C -c
		-D
		-E
		-e
		-F
		-f -g
		-I
		-i
		-J
		-K -k
		-L
		-l
		-M -m
		-N -n
		-O
		-o
		-p
		-Q -q
		-R
		-S -s
		-T -t
		-V -v
		-W -w
		-X -x
		-Y -y
	"

	if [[ $current == -* ]]; then
		COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
		return
	fi

	# Complete hostnames
	local hosts=$(_get_hosts)
	COMPREPLY=( $( compgen -W "$hosts" -- "$current" ) )
}

complete -o default -F _ssh_completion ssh scp sftp

complete -o default -F _ssh_completion ssh
