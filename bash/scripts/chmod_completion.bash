# chmod(1) completion                                      -*- shell-script -*-

function _chmod_completeion()
{
  local current previous
  current=${COMP_WORDS[COMP_CWORD]}
  previous=${COMP_WORDS[COMP_CWORD-1]}

  case $previous in
    --help|--version)
      return
      ;;
    --reference)
      return
      ;;
  esac

  local options="--help --version --reference -R u g o"
  if [[ $current == -* ]]; then
    COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
    [[ $COMPREPLY == *= ]] && compopt -o nospace
    return
  elif [[ $current == u* ]]; then
    options="u+ u- u="
    options=$(_add_accesses "$options")
    COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
    [[ $COMPREPLY == *= ]] && compopt -o nospace
  elif [[ $current == g* ]]; then
    options="g+ g- g="
    options=$(_add_accesses "$options")
    COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
    [[ $COMPREPLY == *= ]] && compopt -o nospace
  elif [[ $current == o* ]]; then
    options="o+ o- o="
    options=$(_add_accesses "$options")
    COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
    [[ $COMPREPLY == *= ]] && compopt -o nospace
  elif [[ $current == *,g* ]]; then
    echo "current = '$current'\n"
    groups="g+ g- g="
    groups=$(_add_accesses "$groups")
    filled_options=""
    for option in ${options[@]}; do
      for group_access in ${groups[@]}; do
        filled_options+=" ${options},${group_access}"
      done
    done
    echo "filled_options = '$filled_options'\n"
    COMPREPLY=( $( compgen -W "$filled_options" -- "$current" ) )
    [[ $COMPREPLY == *= ]] && compopt -o nospace
  elif [[ $current == *,o* ]]; then
    others="o+ o- o="
  elif [[ $COMP_CWORD == 1 ]]; then
    COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
  elif [[ $previous == "-R" ]]; then
    options="u g o"
    COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
  fi
}

function _add_accesses()
{
  local options=$1
  for operation in ${options[@]}; do
    accesses="w x wx rwx rx rw r"
    for access in ${accesses[@]}; do
      options+=" ${operation}${access}"
    done
  done
  echo "$options"
}

complete -o default -F _chmod_completeion chmod
