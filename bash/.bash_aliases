#!/bin/bash

# Make sure .bashrc has:
# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# set -o vi

# unix
alias ls='ls -F --color --group-directories-first'
alias la='ls -A'
alias ll='la -l'
alias :q='exit'
alias ccat='pygmentize -g'
alias g='git'
alias grep='grep --color'
alias less='less -r'
alias print_path='echo $PATH | tr : "\n"'
alias tm='tmux attach || tmux new'
alias vimr='vim ~/.vimrc'

function find()
{
  find $@ | grep '[^/]*$';
}

# Remove broken links by: "findBrokenLinks | exec rm {} \;"
alias find_broken_links='find -L . -type l'

# Solarized
alias sol.dark='source ~/dotfiles/mintty/sol.dark'
alias sol.light='source ~/dotfiles/mintty/sol.light'

# Autocomple searches when using up and down
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

lst()
{
  ls -Rog $1 | grep '^-\|:$'
}

# Bash Prompt
parse_git_branch()
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

git-uplift()
{
  temp_branch="tmp"
  [[ $1 != "" ]] && temp_branch=$1;

  git fetch --all
  # echo "git fetch --all"
  # [[ $(parse_git_branch) =~ \((.+)\) ]] && current_branch=${BASH_REMATCH[1]};
  [[ $(git status -sb) =~ \#\#\ ([^\.]+)\s*\.+origin\/(.+) ]] && current_branch=${BASH_REMATCH[1]} && remote_branch=${BASH_REMATCH[2]};
  echo "current_branch: '$current_branch'"
  echo "remote_branch: '$remote_branch'"
  echo "Press enter."
  read
  git checkout -b $temp_branch origin/$remote_branch --no-track
  # echo "git checkout -b $temp_branch origin/$remote_branch --no-track"
  echo "Press enter."
  read
  # git merge origin/master --no-ff
  echo "git merge origin/master --no-ff"
  echo "Press enter."
  read
  error_code=$?; [[ $error_code != 0 ]] && echo "git mt";
  # git push origin tmp:ref/for/$current_branch
  echo "git push origin tmp:ref/for/$remote_branch"
  echo "Press enter."
  read
  git checkout $current_branch
  # echo "git checkout $current_branch"
  git branch -D $temp_branch
  # echo "git branch -D $temp_branch"
}

# PS1='$(whoami)@$(hostname):$(pwd)>'
RED="\[$(tput setaf 1)\]"
GREEN="\[$(tput setaf 2)\]"
YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
MAGENTA="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
WHITE="\[$(tput setaf 7)\]"
RESET="\[$(tput sgr0)\]"

export DISPLAY=:0.0

export PS1="${CYAN}\A ${BLUE}\u@\h ${GREEN}\w${YELLOW}\$(parse_git_branch \" (%s)\")${RESET} \$ "

norm="$(printf '\033[0m')" #returns to "normal"
bold="$(printf '\033[0;1m')" #set bold
red="$(printf '\033[0;31m')" #set red
boldred="$(printf '\033[0;1;31m')" #set bold, and set red.

alias test='sed -e "s/[a-zA-Z\_\.]\+\:[0-9]\+/${boldred}&${norm}/g"'  # will color any occurence of someregexp in Bold red

# Magento
magento_path='/var/www/html/magento-trial'
alias mage_root='cd $magento_path'
alias mage_theme='mage_root && cd app/design/frontend/Venustheme/'
alias mage_module='mage_root && cd app/code/Ves'
alias mage_build='$magento_path/bin/magento setup:upgrade --keep-generated'
alias mage_static='$magento_path/bin/magento setup:static-content:deploy en_US sv_SE'
alias mage_clear_var='rm -rf $magento_path/var/* && cp $magento_path/.htaccess-var $magento_path/var/.htaccess'

# Solr
solr_path='~/lucene-solr/solr'
alias solar_start='$solr_path/bin/solr start'
alias solar_stop='$solr_path/bin/solr stop'

# Color script
colors_and_formatting()
{
  # Background
  for clbg in {40..47} {100..107} 49 ; do
    #Foreground
    for clfg in {30..37} {90..97} 39 ; do
      #Formatting
      for attr in 0 1 2 4 5 7 ; do
        #Print the result
        echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
      done
      echo #Newline
    done
  done
}

256-colors()
{
  for fgbg in 38 48 ; do # Foreground / Background
    for color in {0..255} ; do # Colors
      # Display the color
      printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
      # Display 6 colors per lines
      if [ $((($color + 1) % 6)) == 4 ] ; then
        echo # New line
      fi
    done
    echo # New line
  done
}
