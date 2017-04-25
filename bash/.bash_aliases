# Make sure .bashrc has:
# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# unix
alias ls='ls --color'
alias la='ls -A'
alias ll='la -l'
alias vimr='vim ~/.vimrc'
# Remove broken links by: "findBrokenLinks | exec rm {} \;"
alias find_broken_links='find -L . -type l'
alias lst='ls -R | grep ":$" | sed -e '"'"'s/:$//'"'"' -e '"'"'s/[^-][^\/]*\//--/g'"'"' -e '"'"'s/^/   /'"'"' -e '"'"'s/-/|/'"'"

PS1='$(whoami)@$(hostname):$(pwd)>'

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
