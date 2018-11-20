#!/bin/bash

# set -o vi
# ctrl-k (until end), ctrl-u (until begin), ctrl-w (backward), ctrl-y (paste) - cutting and pasting text in the command line
# !! to perform last command in this position

if [ -r ~/.bashrc.work ]; then
  . ~/.bashrc.work
fi

dotfiles_dir="$HOME/dotfiles/bash"
source "$dotfiles_dir/_known_hosts.bash"
source "$dotfiles_dir/git-completion.bash"
source "$dotfiles_dir/prompt.bash"

# Variables
#{
EDITOR=vim
export EDITOR
# }

# Aliases
# {
alias ls='ls -F --color --group-directories-first'
alias la='ls -A'
alias ll='la -l'
alias l='ll'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias :q='exit'
alias apt-get='sudo apt-get'
alias bashr='vim ~/.bashrc'
alias c='cat -nv'
alias clr='clear'
alias df="df -h"
alias g='git'
alias g_pl_stash='git stash && git pull --rebase && git stash pop'
alias gitr='vim ~/.gitconfig'
alias gr='cd `git rev-parse --show-toplevel` 2> /dev/null'
alias grep='grep --color'
alias grepc='grep -Rin --color --include=*.{cc,c,h,hh}'
alias grepbb='grep -Rin --color --include=*.bb'
alias grepout="grep -i 'err\\w\\+\\|fail\\w\\+\\|undefined\\|\\w\\+\\.\\(cc\\|h\\):[0-9]\\+\\|$'"
alias h='history'
alias j='jobs -l'
alias less='less -r'
alias mkdir='mkdir -pv'
alias mount='mount | column -t'
alias print_path='echo $PATH | tr : "\n"'
alias psu='ps u --forest'
alias rm='rm -I'
alias tcshr='vim ~/.tcshrc'
alias tm='tmux attach || tmux new'
alias v-split='vim -o'
alias v-tsplit='vim -p'
alias v-vsplit='vim -O'
alias v='vim -p'
alias vimr='vim ~/.vimrc'
alias wget='wget -c'

# Remove broken links by: "findBrokenLinks | exec rm {} \;"
alias find_broken_links='find -L . -type l'

if [[ $UID != 0 ]]; then
  alias reboot='sudo reboot'
  alias update='sudo apt-get update && sudo apt-get upgrade'
fi
# }

function most_used_cmd()
{
  # history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr
  # history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl
  history | tr -s ' ' | cut -d ' ' -f3 | sort | uniq -c | sort -n | tail | perl -lane 'print $F[1], "\t", $F[0], " ", "▄" x ($F[0] / 12)'
}

function most_used_cmd_arguments()
{
  history | tr -s ' ' | cut -d ' ' -f3,4,5,6,7,8,9,10,11 | sort | uniq -c | sort -n # | perl -lane 'print $F[1], "\t", $F[0], " ", "▄" x ($F[0] / 12)'
}

function mcd()
{
  directory="${1}"
  mkdir -p "$directory"
  cd "$directory" || exit
}

function extract()
{
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
        case "${n%,}" in
          *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                  tar xvf "$n"       ;;
          *.lzma) unlzma ./"$n"      ;;
          *.bz2)  bunzip2 ./"$n"     ;;
          *.rar)  unrar x -ad ./"$n" ;;
          *.gz)   gunzip ./"$n"      ;;
          *.zip)  unzip ./"$n"       ;;
          *.z)    uncompress ./"$n"  ;;
          *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                  7z x ./"$n"        ;;
          *.xz)   unxz ./"$n"        ;;
          *.exe)  cabextract ./"$n"  ;;
          *)
                  echo "extract: '$n' - unknown archive method"
                  return 1
                  ;;
        esac
      else
        echo "'$n' - file does not exist"
        return 1
      fi
    done
  fi
}

function fi_()
{
  arguments="${*}"
  (find "${arguments}" | grep '[^\/]*$')
}

function up()
{
  LIMIT=$1
  NEW_PWD=$PWD
  for ((i=1; i <= LIMIT; i++)); do
    NEW_PWD=$NEW_PWD/..
  done
  cd "$NEW_PWD" || exit
  export MPWD=$NEW_PWD
}

function back()
{
  LIMIT=$1
  NEW_PWD=$MPWD
  for ((i=1; i<= LIMIT; i++)); do
    NEW_PWD=${NEW_PWD%/..}
  done
  cd "$NEW_PWD" || exit
  export MPWD=$NEW_PWD
}

# Solarized
alias sol.dark='source ~/dotfiles/mintty/sol.dark'
alias sol.light='source ~/dotfiles/mintty/sol.light'

# Auto complete searches when using up and down
bind '"\e[A":history-search-backward' # ]
bind '"\e[B":history-search-forward' # ]

function my_pylint()
{
  VERSION="${1}"
  PYTHON_FILE="${2}"
  MY_PYLINT="python${VERSION} -m pylint $PYTHON_FILE"
  eval "$MY_PYLINT"
}

# Colors
# {

# Color script
function colors_and_formatting()
{
  # Background
  for clbg in {40..47} {100..107} 49 ; do
    # Foreground
    for clfg in {30..37} {90..97} 39 ; do
      # Formatting
      for attr in 0 1 2 4 5 7 ; do
        # Print the result
        echo -en "\\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \\e[0m"
      done
      echo # Newline
    done
  done
}

function 256-colors()
{
  for fgbg in 38 48 ; do # Foreground / Background
    for color in {0..255} ; do # Colors
      # Display the color
      printf "\\e[${fgbg};5;%sm  %3s  \\e[0m" $color $color
      # Display 6 colors per lines
      if [ $(((color + 1) % 6)) == 4 ] ; then
        echo # New line
      fi
    done
    echo # New line
  done
}

# ls description
# {
# bd = (BLOCK, BLK)   Block device (buffered) special file
# cd = (CHAR, CHR)    Character device (unbuffered) special file
# di = (DIR)  Directory
# do = (DOOR) [Door][1]
# ex = (EXEC) Executable file (ie. has 'x' set in permissions)
# fi = (FILE) Normal file
# ln = (SYMLINK, LINK, LNK)   Symbolic link. If you set this to ‘target’ instead of a numerical value, the color is as for the file pointed to.
# mi = (MISSING)  Non-existent file pointed to by a symbolic link (visible when you type ls -l)
# no = (NORMAL, NORM) Normal (non-filename) text. Global default, although everything should be something
# or = (ORPHAN)   Symbolic link pointing to an orphaned non-existent file
# ow = (OTHER_WRITABLE)   Directory that is other-writable (o+w) and not sticky
# pi = (FIFO, PIPE)   Named pipe (fifo file)
# sg = (SETGID)   File that is setgid (g+s)
# so = (SOCK) Socket file
# st = (STICKY)   Directory with the sticky bit set (+t) and not other-writable
# su = (SETUID)   File that is setuid (u+s)
# tw = (STICKY_OTHER_WRITABLE)    Directory that is sticky and other-writable (+t,o+w)
# *.extension =   Every file using this extension e.g. *.rpm = files with the ending .rpm
# }
LS_COLORS=$LS_COLORS:'di=0;35:ln=0;36:ex=0;33:pi=0;32:so=0;31:bd=0;37:mi=0;36:cd=1;35:tw=0;30:ow=0;34:'
export LS_COLORS

GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32'
export GCC_COLORS
# }

# export DISPLAY=:0.0

# Magento
# {
MAGENTO_PATH="/var/www/html/magento-trial"
alias mage_root="cd \${MAGENTO_PATH}"
alias mage_theme="mage_root && cd app/design/frontend/Venustheme/"
alias mage_module="mage_root && cd app/code/Ves"
alias mage_build="\${MAGENTO_PATH}/bin/magento setup:upgrade --keep-generated"
alias mage_static="\${MAGENTO_PATH}/bin/magento setup:static-content:deploy en_US sv_SE"
alias mage_clear_var="rm -rf \${MAGENTO_PATH}/var/* && cp \${MAGENTO_PATH}/.htaccess-var \${MAGENTO_PATH}/var/.htaccess"
# */
# }

# Solr
# {
SOLR_PATH="${HOME}/lucene-solr/solr"
alias solar_start="\${SOLR_PATH}/bin/solr start"
alias solar_stop="\${SOLR_PATH}/bin/solr stop"
# }

function countdown()
{
  # countdown 60              60 seconds
  # countdown 60*30           30 minutes
  # countdown $((24*60*60))   1 day
  now=$(date +%s)
  date1=$(${now} + "$1");
  while [ "$date1" -ge "$(date +%s)" ]; do
    echo -ne "$(date -u --date @$((date1 - $(date +%s))) +%H:%M:%S)\\r";
    sleep 0.1
  done
}

function stopwatch()
{
  date1=$(date +%s);
  while true; do
    echo -ne "$(date -u --date @$(($(date +%s) - date1)) +%H:%M:%S)\\r";
    sleep 0.1
  done
}
