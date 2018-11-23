unalias .. 2> /dev/null
unalias ... 2> /dev/null

function ..()
{
  local limit=$1
  if [[ $limit == "" ]]; then
    limit=1
  fi
  local new_pwd=$PWD
  for ((i=1; i<= limit; i++)); do
    new_pwd+="/.."
  done
  cd "$new_pwd" || exit
}

function _change_directory_completion()
{
  if [[ $COMP_CWORD == 1 ]]; then
    COMPREPLY=($(compgen -W "1 2 3 4 5" "${COMP_WORDS[1]}"))
  fi
}

complete -F _change_directory_completion ..
