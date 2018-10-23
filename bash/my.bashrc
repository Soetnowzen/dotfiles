#!/bin/bash

# set -o vi
# ctrl-k (until end), ctrl-u (until begin), ctrl-w (backward), ctrl-y (paste) - cutting and pasting text in the command line
# !! to perform last command in this position

if [ -r ~/.bashrc.work ]; then
  . ~/.bashrc.work
fi

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
alias fi_="find \$$ | grep '[^\\/]*$'"
alias g='git'
alias g_pl_stash='git stash && git pull --rebase && git stash pop'
alias gitr='vim ~/.gitconfig'
alias gr='cd `git rev-parse --show-toplevel` 2> /dev/null'
alias grep='grep --color'
alias grepc='grep -Rin --color --include=*.{cc,c,h,hh}'
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
    echo "${number_of_changes}"
  fi
}

commit_count()
{
  git_commits_behind=$(git status -uno | grep -i 'Your branch is' | grep -Eo '[0-9]+')
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
ORANGE="$(tput setaf 9)"
VIOLET="$(tput setaf 13)"
BLACK="$(tput setaf 16)"
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
LS_COLORS=$LS_COLORS:'di=0;35:ln=0;36:ex=0;33:pi=0;32:so=0;31:bd=0;37:mi=0;36:cd=1;35:tw=0;30:ow=0;34:'
# LS_COLORS=$LS_COLORS:"di=${MAGENTA}:ln=${CYAN}:ex=${YELLOW}:pi=${GREEN}:so=${RED}:bd=${WHITE}:mi=${CYAN}:cd=1;35:tw=0;30:ow=${BLUE}:"
export LS_COLORS

GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32'
# GCC_COLORS="error=${RED}:warning=${MAGENTA}:note=${CYAN}:caret=${GREEN}:locus=01:quote=01:fixit-insert=${GREEN}:fixit-delete=${RED}:diff-filename=${RED}:diff-hunk=${GREEN}:diff-delete=${RED}:diff-insert=${GREEN}:type-diff=${GREEN}"
export GCC_COLORS
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
  if [[ $EXIT != 0 ]]; then
    PS1+="\\[${RED}\\]"
  else
    PS1+="\\[${BLUE}\\]"
  fi
  PS1+="\\u\\[${RESET}\\]@\\[${BLUE}\\]\\h\\[${RESET}\\] "
  # Path
  PS1+="\\[${GREEN}\\]\\w"
  # Get current git branch
  branch=$(parse_git_branch)
  if [[ ${branch} != "" ]]; then
    PS1+="\\[${YELLOW}\\](${branch}"
    __git_prompt
  fi
  if [[ $EXIT != 0 ]]; then
    # Print exit code if not 0
    PS1+=" \\[${RED}\\]${EXIT}"
  fi

  PS1+="\\[${RESET}\\]]\\n\\$ "
}

function __git_prompt()
{
  __git_tag_prompt
  __git_modifications_prompt
  __git_commit_status
  __git_stash_count
  PS1+=")"
}

function __git_tag_prompt()
{
  git_tag=$(git tag -l --points-at HEAD 2> /dev/null)
  if [[ ${git_tag} != "" ]]; then
    PS1+=", \\[${WHITE}\\]${git_tag}\\[${YELLOW}\\]"
  fi
}

function __git_modifications_prompt()
{
  git_count=$(modified_git_count)
  if [[ ${git_count} != "" ]]; then
    PS1+=", \\[${MAGENTA}\\]${git_count}"
    git_diff_word=$(git diff --word-diff 2> /dev/null | grep '\[-.*-\]\|{+.*+}')
    if [[ ${git_diff_word} != "" ]]; then
      change_rows=$(echo "${git_diff_word}" | grep -c '\[-.*-\]{+.*+}')
      if [[ ${change_rows} != "0" ]]; then
        PS1+=" \\[${YELLOW}\\]~${change_rows}"
      fi
      plus_rows=$(echo "${git_diff_word}" | grep -cv '\[-.*-\]')
      if [[ ${plus_rows} != "0" ]]; then
        PS1+=" \\[${GREEN}\\]+${plus_rows}"
      fi
      minus_rows=$(echo "${git_diff_word}" | grep -cv '{+.*+}')
      if [[ ${minus_rows} != "0" ]]; then
        PS1+=" \\[${RED}\\]-${minus_rows}"
      fi
    fi
    PS1+="\\[${YELLOW}\\]"
  fi
}

function __git_commit_status()
{
  git_commits_behind=$(git status -uno | grep -i 'Your branch' | grep -Eo '[0-9]+|diverged|behind|ahead')
  if [[ ${git_commits_behind} != "" ]]; then
    git_commits_behind=$(echo "$git_commits_behind" | tr '\n' ' ' | xargs)
    PS1+=", \\[${VIOLET}\\]${git_commits_behind}\\[${RESET}${YELLOW}\\]"
  fi
}

function __git_stash_count()
{
  git_stash_count=$(git stash list 2> /dev/null | wc -l)
  if [[ ${git_stash_count} != "0" ]]; then
    PS1+=", stash@{\\[${ORANGE}\\]${git_stash_count}\\[${YELLOW}\\]}"
  fi
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
