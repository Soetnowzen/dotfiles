# bash completion for GNU find                             -*- shell-script -*-
# This makes heavy use of ksh style extended globs and contains Linux specific
# code for completing the parameter to the -fstype option; do.

_find()
{
  local cur prev words cword
  _init_completion || return

  case $prev in
    -maxdepth|-mindepth)
      COMPREPLY=( $( compgen -W '{0..9}' -- "$cur" ) )
      return
      ;;
      -newer|-anewer|-cnewer|-fls|-fprint|-fprint0|-fprintf|-name|-iname|\
        -lname|-ilname|-wholename|-iwholename|-samefile)
      _filedir
      return
      ;;
    -fstype)
      _fstypes
      [[ $OSTYPE == *bsd* ]] && \
        COMPREPLY+=( $( compgen -W 'local rdonly' -- "$cur" ) )
      return
      ;;
    -gid)
      _gids
      return
      ;;
    -group)
      COMPREPLY=( $( compgen -g -- "$cur" 2>/dev/null) )
      return
      ;;
    -xtype|-type)
      COMPREPLY=( $( compgen -W 'b c d p f l s' -- "$cur" ) )
      return
      ;;
    -uid)
      _uids
      return
      ;;
    -user)
      COMPREPLY=( $( compgen -u -- "$cur" ) )
      return
      ;;
    -exec|-execdir|-ok|-okdir)
      words=(words[0] "$cur")
      cword=1
      _command
      return
      ;;
      -[acm]min|-[acm]time|-iname|-lname|-wholename|-iwholename|-lwholename|\
        -ilwholename|-inum|-path|-ipath|-regex|-iregex|-links|-perm|-size|\
        -used|-printf|-context)
      # do nothing, just wait for a parameter to be given
      return
      ;;
    -regextype)
      COMPREPLY=( $( compgen -W 'emacs posix-awk posix-basic posix-egrep
      posix-extended' -- "$cur" ) )
      return
      ;;
  esac

  local i exprfound=false
  # set exprfound to true if [there is already an expression present]
  for i in ${words[@]}; do
    [[ "$i" == [-\(\),\!]* ]] && exprfound=true && break
  done
  # handle case where first parameter is not a dash option
  if ! $exprfound && [[ "$cur" != [-\(\),\!]* ]]; then
    _filedir -d
    return
  fi

  # complete using basic options
  COMPREPLY=( $( compgen -W '-daystart -depth -follow -help
  -ignore_readdir_race -maxdepth -mindepth -mindepth -mount
  -noignore_readdir_race -noleaf -regextype -version -warn -nowarn -xdev
  -amin -anewer -atime -cmin -cnewer -ctime -empty -executable -false
  -fstype -gid -group -ilname -iname -inum -ipath -iregex -iwholename
  -links -lname -mmin -mtime -name -newer -nogroup -nouser -path -perm
  -readable -regex -samefile -size -true -type -uid -used -user
  -wholename -writable -xtype -context -delete -exec -execdir -fls
  -fprint -fprint0 -fprintf -ls -ok -okdir -print -print0 -printf -prune
  -quit' -- "$cur" ) )

  if [[ ${#COMPREPLY[@]} -ne 0 ]]; then
    # this removes any options from the list of completions that have
    # already been specified somewhere on the command line, as long as
    # these options can only be used once (in a word, "options", in
    # opposition to "tests" and "actions", as in the find(1) manpage)
    local -A onlyonce=( [-daystart]=1 [-depth]=1 [-follow]=1 [-help]=1
    [-ignore_readdir_race]=1 [-maxdepth]=1 [-mindepth]=1 [-mount]=1
    [-noignore_readdir_race]=1 [-noleaf]=1 [-nowarn]=1 [-regextype]=1
    [-version]=1 [-warn]=1 [-xdev]=1 )
    local j
    for i in "${words[@]}"; do
      [[ $i && ${onlyonce[$i]} ]] || continue
      for j in ${!COMPREPLY[@]}; do
        [[ ${COMPREPLY[j]} == $i ]] && unset 'COMPREPLY[j]'
      done
    done
  fi

  _filedir

}

function _find_completion()
{
  local current previous
  current=${COMP_WORDS[COMP_CWORD]}
  previous=${COMP_WORDS[COMP_CWORD-1]}

  case $previous in
    -maxdepth|-mindepth)
      COMPREPLY=( $( compgen -W '{0..9}' -- "$current" ) )
      return
      ;;
      -newer|-anewer|-cnewer|-fls|-fprint|-fprint0|-fprintf|-name|-iname|\
        -lname|-ilname|-wholename|-iwholename|-samefile)
      _filedir
      return
      ;;
    -fstype)
      _fstypes
      [[ $OSTYPE == *bsd* ]] && \
        COMPREPLY+=( $( compgen -W 'local rdonly' -- "$current" ) )
      return
      ;;
    -gid)
      _gids
      return
      ;;
    -group)
      COMPREPLY=( $( compgen -g -- "$current" 2>/dev/null) )
      return
      ;;
    -xtype|-type)
      COMPREPLY=( $( compgen -W 'b c d p f l s' -- "$current" ) )
      return
      ;;
    -uid)
      _uids
      return
      ;;
    -user)
      COMPREPLY=( $( compgen -u -- "$current" ) )
      return
      ;;
    -exec|-execdir|-ok|-okdir)
      words=(words[0] "$current")
      cword=1
      _command
      return
      ;;
      -[acm]min|-[acm]time|-iname|-lname|-wholename|-iwholename|-lwholename|\
        -ilwholename|-inum|-path|-ipath|-regex|-iregex|-links|-perm|-size|\
        -used|-printf|-context)
      # do nothing, just wait for a parameter to be given
      return
      ;;
    -regextype)
      COMPREPLY=( $( compgen -W 'emacs posix-awk posix-basic posix-egrep
      posix-extended' -- "$current" ) )
      return
      ;;
  esac

  local basic_options='-daystart -depth -follow -help
  -ignore_readdir_race -maxdepth -mindepth -mindepth -mount
  -noignore_readdir_race -noleaf -regextype -version -warn -nowarn -xdev
  -amin -anewer -atime -cmin -cnewer -ctime -empty -executable -false
  -fstype -gid -group -ilname -iname -inum -ipath -iregex -iwholename
  -links -lname -mmin -mtime -name -newer -nogroup -nouser -path -perm
  -readable -regex -samefile -size -true -type -uid -used -user
  -wholename -writable -xtype -context -delete -exec -execdir -fls
  -fprint -fprint0 -fprintf -ls -ok -okdir -print -print0 -printf -prune
  -quit'
  if [[ $current == -* ]]; then
    COMPREPLY=( $( compgen -W "$basic_options" -- "$current" ) )
    [[ $COMPREPLY == *= ]] && compopt -o nospace
    return
  fi
}

complete -o default -F _find_completion find

# ex: filetype=sh
