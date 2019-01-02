
RED="\\[$(tput setaf 1)\\]"
GREEN="\\[$(tput setaf 2)\\]"
YELLOW="\\[$(tput setaf 3)\\]"
BLUE="\\[$(tput setaf 4)\\]"
MAGENTA="\\[$(tput setaf 5)\\]"
CYAN="\\[$(tput setaf 6)\\]"
WHITE="\\[$(tput setaf 7)\\]"
ORANGE="\\[$(tput setaf 9)\\]"
VIOLET="\\[$(tput setaf 13)\\]"
BLACK="\\[$(tput setaf 16)\\]"
UNDERLINE="\\[$(tput smul)\\]"
EXIT_UNDERLINE="\\[$(tput rmul)\\]"
RESET="\\[$(tput sgr0)\\]"

PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command()
{
  # This needs to be first
  local EXIT="$?"
  PS1="[" # ]

  # Time
  PS1+="$CYAN\\A "
  # user@pc
  if [[ $EXIT != 0 ]]; then
    PS1+="$RED"
  else
    PS1+="$BLUE"
  fi
  PS1+="\\u$RESET@$BLUE\\h$RESET "
  # Path
  PS1+="$GREEN\\w"
  # Get current git branch
  branch=$(__parse_git_branch)
  if [[ ${branch} != "" ]]; then
    PS1+="$YELLOW(${branch}"
    __git_prompt
    PS1+=")"
  fi
  if [[ $EXIT != 0 ]]; then
    # Print exit code if not 0
    PS1+=" $RED✘${EXIT}"
  fi

  PS1+="$RESET]\\n\\$ "
}

function __parse_git_branch()
{
  branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  # position="$(git describe --contains --all HEAD 2> /dev/null)"
  # */
  echo "${branch}"
}

function __git_prompt()
{
  __git_tag_prompt
  __git_modifications_prompt
  __git_commit_status
  __git_stash_count
}

function __git_tag_prompt()
{
  git_tag=$(git tag -l --points-at HEAD 2> /dev/null)
  if [[ ${git_tag} != "" ]]; then
    PS1+=", $WHITE${git_tag}$YELLOW"
  fi
}

function __git_modifications_prompt()
{
  __modified_files_count
  git_count=$(git diff --word-diff 2> /dev/null)
  if [[ ${git_count} != "" ]]; then
    git_diff_word=$(echo "$git_count" | grep '\[-.*-\]\|{+.*+}')
    if [[ ${git_diff_word} != "" ]]; then
      PS1+=","
      change_rows=$(echo "${git_diff_word}" | grep -c '\[-.*-\]{+.*+}')
      if [[ ${change_rows} != "0" ]]; then
        PS1+=" $YELLOW~${change_rows}"
      fi
      plus_rows=$(echo "${git_diff_word}" | grep -cv '\[-.*-\]')
      if [[ ${plus_rows} != "0" ]]; then
        PS1+=" $GREEN+${plus_rows}"
      fi
      minus_rows=$(echo "${git_diff_word}" | grep -cv '{+.*+}')
      if [[ ${minus_rows} != "0" ]]; then
        PS1+=" $RED-${minus_rows}"
      fi
    fi
    PS1+="$YELLOW"
  fi
}

function __modified_files_count()
{
  git_status=$(git status -s 2> /dev/null)
  if [[ ${git_status} != "" ]]; then
    PS1+=","
    added_files=$(echo "${git_status}" | grep -c '^A ')
    if [[ $added_files != 0 ]]; then
      PS1+=" $GREEN✚${added_files}"
      # PS1+=" $GREEN+${added_files}"
    fi
    deleted_files=$(echo "${git_status}" | grep -c '^\s*D')
    if [[ $deleted_files != 0 ]]; then
      PS1+=" $RED✖${deleted_files}"
      # PS1+=" $RED-${deleted_files}"
    fi
    modified_files=$(echo "${git_status}" | grep -c '^\s*M')
    if [[ $modified_files != 0 ]]; then
      PS1+=" $BLUE✱${modified_files}"
      # PS1+=" $BLUE~${modified_files}"
    fi
    renamed_files=$(echo "${git_status}" | grep -c '^R ')
    if [[ $renamed_files != 0 ]]; then
      PS1+=" $MAGENTA➜${renamed_files}"
      # PS1+=" $MAGENTA>${renamed_files}"
    fi
    unmerged_files=$(echo "${git_status}" | grep -c '^UU')
    if [[ $unmerged_files != 0 ]]; then
      PS1+=" $YELLOW=${unmerged_files}"
    fi
    untraced_files=$(echo "${git_status}" | grep -c '^??')
    if [[ $untraced_files != 0 ]]; then
      PS1+=" $WHITE◼${untraced_files}"
      # PS1+=" $WHITE?${untraced_files}"
    fi
    PS1+="$YELLOW"
  fi
}

function __git_commit_status()
{
  git_commit_status=$(git status -uno | grep -i 'Your branch' | grep -Eo 'by [0-9]+|diverged|behind|ahead')
  if [[ ${git_commit_status} != "" ]]; then
    PS1+=", $VIOLET"
    if [[ $(echo "$git_commit_status" | grep -Eo 'ahead') != "" ]]; then
      PS1+="⬆"
      # PS1+="^"
    elif [[ $(echo "$git_commit_status" | grep -Eo 'behind') != "" ]]; then
      PS1+="⬇"
      # PS1+="v"
    elif [[ $(echo "$git_commit_status" | grep -Eo 'diverged') != "" ]]; then
      PS1+="diverged"
    fi
    number_of_commits=$(echo "$git_commit_status" | grep -Eo '[0-9]+')
    PS1+="${number_of_commits}$YELLOW"
  fi
}

function __git_stash_count()
{
  git_stash_count=$(git stash list 2> /dev/null | wc -l)
  if [[ ${git_stash_count} != "0" ]]; then
    PS1+=", $ORANGE✭${git_stash_count}$YELLOW"
  fi
}
