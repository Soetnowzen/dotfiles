#!/bin/bash

# set -o vi

if [ -r ~/.bashrc.work ]; then
  . ~/.bashrc.work
fi

# Aliases
# {
alias ls='ls -F --color --group-directories-first'
alias la='ls -A'
alias ll='la -l'
alias ..='cd ..'
alias :q='exit'
alias bashr='vim ~/.bashrc'
alias c='cat -nv'
alias ccat='pygmentize -g'
alias clr='clear'
alias fi_="find \$$ | grep '[^\\/]*$'"
alias g='git'
alias g_pl_stash='git stash && git pull --rebase && git stash pop'
alias gitr='vim ~/.gitconfig'
alias grep='grep --color'
alias grepc='grep -Rin --color --include=*.{cc,h}'
alias h='history'
alias less='less -r'
alias mkdir='mkdir -pv'
alias mount='mount | column -t'
alias print_path='echo $PATH | tr : "\n"'
alias psu='ps -u --forest'
alias rm='rm -I'
alias tm='tmux attach || tmux new'
alias v-split='vim -o'
alias v-tsplit='vim -p'
alias v-vsplit='vim -O'
alias v='vim'
alias vimr='vim ~/.vimrc'
# alias most_used="history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | grep -v \"./\" | column -c3 -s \" \" -t | sort -nr | nl |  head -n10"
# }

most_used_cmd()
{
  # history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr
  # history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl
  history | tr -s ' ' | cut -d ' ' -f3 | sort | uniq -c | sort -n | tail | perl -lane 'print $F[1], "\t", $F[0], " ", "▄" x ($F[0] / 12)'
}

most_used_cmd_arguments()
{
  history | tr -s ' ' | cut -d ' ' -f3,4,5,6,7,8,9,10,11 | sort | uniq -c | sort -n # | perl -lane 'print $F[1], "\t", $F[0], " ", "▄" x ($F[0] / 12)'
}

mcd()
{
  directory="${1}"
  mkdir -p "$directory"
  cd "$directory" || exit
}

extract()
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

fi_a ()
{
  arguments="${*}"
  echo "'${arguments}'"
  for line in $(find "$arguments" | grep '[^\/]*$'); do
    # line = grep '[^\/]*$' "${line}"
    echo "${line}"
  done
  # find "${arguments}" -print0 | while IFS= read -r -d $'\0' line; do
    # | grep '[^\/]*$'
    # echo "${line}"
  # done
  # find . -type f -iname "*.txt" -print0 | while IFS= read -r -d $'\0' line; do
    # echo "$line"
    # ls -l "$line"
  # done
}

# Remove broken links by: "findBrokenLinks | exec rm {} \;"
alias find_broken_links='find -L . -type l'

# Solarized
alias sol.dark='source ~/dotfiles/mintty/sol.dark'
alias sol.light='source ~/dotfiles/mintty/sol.light'

# Auto complete searches when using up and down
bind '"\e[A":history-search-backward' # ]
bind '"\e[B":history-search-forward' # ]

my_pylint()
{
  VERSION="${1}"
  PYTHON_FILE="${2}"
  MY_PYLINT="python${VERSION} -m pylint $PYTHON_FILE"
  eval "$MY_PYLINT"
}

# Bash Prompt
parse_git_branch()
{
  branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  # */
  echo "${branch}"
}

modified_git_count()
{
  number_of_changes=$(git status -s -uno 2> /dev/null | wc -l)
  if [[ ${number_of_changes} != 0 ]]; then
    echo "+${number_of_changes}"
  fi
}

# Colors
# {
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
GREY="$(tput setaf 9)"
VIOLET="$(tput setaf 13)"
BLACK="$(tput setaf 16)"
BOLD="$(tput bold)"
UNDERLINE="$(tput smul)"
EXIT_UNDERLINE="$(tput rmul)"
RESET="$(tput sgr0)"

# Color script
colors_and_formatting()
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

256-colors()
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
LS_COLORS=$LS_COLORS:'di=0;35:ln=0;36:ex=0;33:pi=0;32:so=0;31:bd=0;37:mi=0;36:cd=1;35:tw=0;30:ow=0;34:' ; export LS_COLORS
# }

# export DISPLAY=:0.0

color_current_directory()
{
  relative_path="${1}"
  relative_path="$(echo "${relative_path}" | sed -e "s/\\([^\\/]\\+$\\)/\\[${UNDERLINE}\\]\\1\\[${EXIT_UNDERLINE}\\]/")"
  echo -e "${relative_path}"
}

PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command()
{
  # This needs to be first
  local EXIT="$?"
  PS1="[" # ]

  # Time
  PS1+="\\[${CYAN}\\]\\A "
  # user@pc
  PS1+="\\[${BLUE}\\]\\u\\[${RESET}\\]@\\[${BLUE}\\]\\h\\[${RESET}\\] "
  # Path
  PS1+="\\[${GREEN}\\]\\w"
  # Get current git branch
  branch=$(parse_git_branch)
  if [[ ${branch} != "" ]]; then
    PS1+="\\[${YELLOW}\\](${branch}"
    git_tag=$(git tag -l --points-at HEAD 2> /dev/null)
    if [[ ${git_tag} != "" ]]; then
      PS1+=", \\[${WHITE}\\]\\[${VIOLET}\\]${git_tag}\\[${YELLOW}\\]"
    fi
    git_count=$(modified_git_count)
    if [[ ${git_count} != "" ]]; then
      PS1+=", \\[${MAGENTA}\\]${git_count}\\[${YELLOW}\\]"
    fi
    git_stash_count=$(git stash list 2> /dev/null | wc -l)
    if [[ ${git_stash_count} != "" ]]; then
      PS1+=", \\[${GREY}\\]+${git_stash_count}\\[${YELLOW}\\]"
    fi
    PS1+=")"
  fi
  if [[ $EXIT != 0 ]]; then
    # Print exit code if not 0
    PS1+=" \\[${RED}\\]${EXIT}"
  fi

  PS1+="\\[${RESET}\\]]\\$ "
}

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

# countdown 60              60 seconds
# countdown 60*30           30 minutes
# countdown $((24*60*60))   1 day
function countdown()
{
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
