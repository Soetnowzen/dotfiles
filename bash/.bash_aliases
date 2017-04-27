#!/bin/zsh

# Make sure .bashrc has:
# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# unix
alias ls='ls --color --group-directories-first'
alias la='ls -A'
alias ll='la -l'
alias vimr='vim ~/.vimrc'
# Remove broken links by: "findBrokenLinks | exec rm {} \;"
alias find_broken_links='find -L . -type l'
alias lst1='ls -R | grep ":$" | sed -e '"'"'s/:$//'"'"' -e '"'"'s/[^-][^\/]*\//--/g'"'"' -e '"'"'s/^/   /'"'"' -e '"'"'s/-/|/'"'"
# alias lst1='find . -print | sed -e '"'"'/^\.$/d'"'"' -e '"'"'s/[^-][^\/]*\//--/g'"'"' -e '"'"'s/^/   /'"'"' -e '"'"'s/-/|/'"'"
lst() {
  find $1 -print | sed -e '/^\.$/d' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

# Bash Prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
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

export PS1="${BLUE}\u@\h ${GREEN}\w${YELLOW}\$(parse_git_branch)${RESET}\n$ "

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
