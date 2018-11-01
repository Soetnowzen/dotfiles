#
# A simple theme that displays relevant, contextual information.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Screenshots:
#   http://i.imgur.com/nrGV6pg.png
#

#
# 16 Terminal Colors
# -- ---------------
#  0 black
#  1 red
#  2 green
#  3 yellow
#  4 blue
#  5 magenta
#  6 cyan
#  7 white
#  8 bright black
#  9 bright red
# 10 bright green
# 11 bright yellow
# 12 bright blue
# 13 bright magenta
# 14 bright cyan
# 15 bright white
#

# Load dependencies.
#pmodload 'helper'

function prompt_sorin_pwd {
  local pwd="${PWD/#$HOME/~}"

  if [[ "$pwd" == (#m)[/~] ]]; then
    _prompt_sorin_pwd="$MATCH"
    unset MATCH
  else
    _prompt_sorin_pwd="${${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}//\%/%%}/${${pwd:t}//\%/%%}"
  fi
}

function prompt_sorin_git_info {
  if (( _prompt_sorin_precmd_async_pid > 0 )); then
    # Append Git status.
    if [[ -s "$_prompt_sorin_precmd_async_data" ]]; then
      alias typeset='typeset -g'
#      source "$_prompt_sorin_precmd_async_data"
      eval "$(<$_prompt_sorin_precmd_async_data)"
      RPROMPT+='${git_info:+${(e)git_info[status]}}'
      unalias typeset
    else
      RPROMPT+="nopid"
    fi

    # Reset PID.
    _prompt_sorin_precmd_async_pid=0

    # Redisplay prompt.
    zle && zle .reset-prompt
  fi
}

function prompt_sorin_precmd_async {
  # Get Git repository information.
  if (( $+functions[git-info] )); then
    git-info
    typeset -g -p git_info >! "$_prompt_sorin_precmd_async_data"
#    echo "$git_info" >! "$_prompt_sorin_precmd_async_data"
  else
    RPROMPT+="nogit"
  fi

  # Signal completion to parent process.
  kill -WINCH $$
}

function prompt_sorin_precmd {
  LAST_RET=$?
  if [[ $LAST_RET -gt 0 ]]; then
    RET_STR="%{$fg[red]%}@%B$LAST_RET%b%{$reset_color%}"
  else
    RET_STR=' '
  fi

  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS

  # Format PWD.
  prompt_sorin_pwd

  # Define prompts.
  RPROMPT='${(e)editor_info[overwrite]}$RET_STR${VIM:+" %B%{$fg[cyan]%}V%{$reset_color%}%b"}'

  # Kill the old process of slow commands if it is still running.
  if (( _prompt_sorin_precmd_async_pid > 0 )); then
    kill -KILL "$_prompt_sorin_precmd_async_pid" &>/dev/null
  fi

  # Compute slow commands in the background.
  trap prompt_sorin_git_info WINCH
  prompt_sorin_precmd_async &!
  _prompt_sorin_precmd_async_pid=$!
}

function prompt_sorin_cleanup {
  rm $_prompt_sorin_precmd_async_data
}

function prompt_sorin_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)
  _prompt_sorin_precmd_async_pid=0
  _prompt_sorin_precmd_async_data=$(mktemp "${TMPDIR}/sorin-prompt-async-XXXXXXXXXX")

  # Load required functions.
  autoload -Uz add-zsh-hook

  # Add hook for calling git-info before each command.
  add-zsh-hook precmd prompt_sorin_precmd
  add-zsh-hook zshexit prompt_sorin_cleanup

  # Set editor-info parameters.
  zstyle ':prezto:module:editor:info:completing' format '%B%{$fg[default]%}...%{$reset_color%}%b'
  zstyle ':prezto:module:editor:info:keymap:primary' format ' %B%{$fg[red]%}>%{$fg[yellow]%}>%{$fg[green]%}>%{$reset_color%}%b'
  zstyle ':prezto:module:editor:info:keymap:primary:overwrite' format ' %{$fg[yellow]%}!%{$reset_color%}'
  zstyle ':prezto:module:editor:info:keymap:alternate' format ' %B%{$fg[green]%}<%{$fg[yellow]%}<%{$fg[red]%}<%{$reset_color%}%b'

  # Set git-info parameters.
  zstyle ':prezto:module:git:info' verbose 'yes'
  zstyle ':prezto:module:git:info:action' format '%%{$fg[default]%}:%{$reset_color%}%%B%%{$fg_bold[red]%}%s%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:added' format ' %%B%{$fg[green]%}%a+%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:ahead' format ' %%B%%{$fg_bold[magenta]%}%A^%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:behind' format ' %%B%%{$fg_bold[magenta]%}%Bv%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:branch' format ' %%B%{$fg[green]%}%b%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:commit' format ' %%B%{$fg[yellow]%}%.7c%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:deleted' format ' %%B%{$fg[red]%}%dx%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:modified' format ' %%B%{$fg[blue]%}%m*%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:position' format ' %%B%%{$fg_bold[magenta]%}%p%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:renamed' format ' %%B%{$fg[green]%}%r>%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:stashed' format ' %%B%{$fg[cyan]%}%Ss%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:unmerged' format ' %%B%{$fg[yellow]%}%U=%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:untracked' format ' %%B%%{$fg[default]%}%u?%{$reset_color%}%%b'
  zstyle ':prezto:module:git:info:keys' format \
    'status' '$(coalesce "%b" "%p" "%c")%s%A%B%S%a%d%m%r%U%u'

  # Define prompts.
  PROMPT='${SSH_TTY:+"%{$fg_bold[red]%}%n%{$reset_color%}%{$fg[default]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%} "}%{$fg[blue]%}${_prompt_sorin_pwd}%(!. %B%{$fg[red]%}#%{$reset_color%}%b.)${(e)editor_info[keymap]} '
  RPROMPT=''
  SPROMPT='zsh: correct %{$fg[red]%}%R%{$reset_color%} to %{$fg[green]%}%r%{$reset_color%} [nyae]? '
}

prompt_sorin_setup "$@"

