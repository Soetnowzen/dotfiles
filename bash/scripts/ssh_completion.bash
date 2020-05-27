function _get_hosts()
{
  local results=""
  local hosts=$(grep '\<Host\>' ~/.ssh/config)
  for host in $hosts; do
    if [[ "$host" != "Host" ]]; then
      results+="$host "
    fi
  done
  echo "$results"
}

function _ssh_completion()
{
  local current previous
  current=${COMP_WORDS[COMP_CWORD]}
  previous=${COMP_WORDS[COMP_CWORD-1]}

  if [[ $COMP_CWORD -gt 2 ]]; then
    return
  fi
  if [[ $current == -* ]]; then
    local options="-Y -X"
    COMPREPLY=($(compgen -W "$options" -- "$current"))
    [[ $COMPREPLY == *= ]] && compopt -o nospace
    return
  else
    # local results="-Y -X "
    local results=""
    if [[ $previous == -* ]]; then
      results=$(_get_hosts)
    elif [[ $previous == "ssh" ]]; then
      results="-Y -X $(_get_hosts)"
    else
      results="-Y -X"
    fi
    COMPREPLY=($(compgen -W "$results" -- "$current"))
  fi
}

complete -o default -F _ssh_completion ssh
