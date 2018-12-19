
function _chown_completion()
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

  local options="--help --version --reference -R"
  if [[ $current == -* ]]; then
    COMPREPLY=( $( compgen -W "$options" -- "$current" ) )
    [[ $COMPREPLY == *= ]] && compopt -o nospace
    return
  else
    if [[ $current == *: ]]; then
      groups=$(groups)
      # for group in ${groups[@]}; do
      # done
      COMPREPLY=( $( compgen -W "$groups" -- "$current" ) )
    else
      users=$(users)
      COMPREPLY=( $( compgen -W "$users" -- "$current" ) )
      [[ $COMPREPLY == *= ]] && compopt -o nospace
    fi
    # user:group
  fi
}

complete -o default -F _chown_completion chown

