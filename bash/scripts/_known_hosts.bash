function _known_hosts()
{
  if [[ $COMP_CWORD -eq 1 ]]; then
    hosts=$(grep '\<Host\>' ~/.ssh/config)
    results=""
    for host in $hosts; do
      if [[ "$host" != "Host" ]]; then
        results+="$host "
      fi
    done
    COMPREPLY=($(compgen -W "$results" "${COMP_WORDS[1]}"))
  fi
}

complete -F _known_hosts ssh
