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
alias grep='grep --color'
alias print_path='echo $PATH | tr : "\n"'
alias tm='tmux attach || tmux new'
alias vimr='vim ~/.vimrc'

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

git_uplift()
{
  temp_name="tmp"
  echo $temp_name
  if [[ $1 != "" ]]; then
    temp_name=$1
  fi
  echo $temp_name

  # git fetch --all
  echo "git fetch --all"
  echo $(parse_git_branch)
  if [[ $(parse_git_branch)=~"\((.+)\)" ]]; then
    echo "1: $1"
    current_branch=$1
  else
    echo "no"
    echo $(parse_git_branch)
  fi
  echo "current_branch: $current_branch"
  # git checkout -b $(temp_name) origin/$(current_branch) --no-track
  echo "git checkout -b $temp_name origin/$current_branch --no-track"
  # read
  # merge_message = "$(git merge origin/master --no-ff)"
  # echo "merge_message = \"$(git merge origin/master --no-ff)\""
  # if [[ merge_message == "MERGE CONFLICT" ]]; then
    # git mt
    # echo "git mt"
  # fi
  # git push origin tmp:ref/for/$(current_branch)
  # echo "git push origin tmp:ref/for/$(current_branch)"
  # git checkout $(current_branch)
  # echo "git checkout $(current_branch)"
  # git branch -D $(temp_name)
  echo "git branch -D $temp_name"
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

export DISPLAY=:0

export PS1="${BLUE}\u@\h ${GREEN}\w${YELLOW}\$(parse_git_branch \" (%s)\")${RESET} \$ "

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
