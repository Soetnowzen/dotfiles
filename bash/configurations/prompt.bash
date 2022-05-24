
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
ORANGE="$(tput setaf 9)"
VIOLET="$(tput setaf 13)"
# BLACK="\\[$(tput setaf 16)\\]"
# UNDERLINE="\\[$(tput smul)\\]"
# EXIT_UNDERLINE="\\[$(tput rmul)\\]"
RESET="$(tput sgr0)"

function __prompt_command()
{
  local args=("$@")
  local EXIT="${args[0]}"
  local dirs_count="${args[1]}"
  local jobs_count="${args[2]}"
  printf "[" # ]

  # Time
  printf "%s%s " "$CYAN" "$(date +%H:%M)"
  # user@pc
  if [[ $EXIT != 0 ]]; then
      printf "%s" "$RED"
  else
    printf "%s" "$BLUE"
  fi
  printf "%s%s@%s%s%s " "$(whoami)" "$RESET" "$BLUE" "$(hostname)" "$RESET"
  # Path
  printf "%s%s" "$GREEN" "$(pwd)"
  # __smaller_path
  __count_dirs_stack "$dirs_count"
  __count_jobs_stack "$jobs_count"
  # Get current git branch
  branch=$(__parse_git_branch)
  if [[ ${branch} != "" ]]; then
    printf "%s(%s" "$YELLOW" "$branch"
    __git_prompt
    printf ")"
  fi
  if [[ $EXIT != 0 ]]; then
    # Print exit code if not 0
    # printf " %sX${EXIT}" "$RED"
    if [[ $EXIT == 1 ]]; then
      printf " %sCatchall for general errors (${EXIT}✘)" "$RED"
    elif [[ $EXIT == 2 ]]; then
      printf " %sMisuse of shell builtins (${EXIT}✘)" "$RED"
    elif [[ $EXIT == 126 ]]; then
      printf " %sCommand invoked cannot execute (${EXIT}✘)" "$RED"
    elif [[ $EXIT == 127 ]]; then
      printf " %sCommand not found (${EXIT}✘)" "$RED"
    elif [[ $EXIT == 130 ]]; then
      printf " %sScript terminated by Control-C (${EXIT}✘)" "$RED"
    elif [[ $EXIT -gt 128 ]] && [[ $EXIT -lt 255 ]]; then
      printf " %sFatal error signal 'n=%s' (${EXIT}✘)" $(($EXIT-128)) "$RED"
    else
      printf " %s✘${EXIT}" "$RED"
    fi
  fi

  printf "%s]\\n" "$RESET"
}

function __smaller_path()
{
  local directories
  directories=$(pwd | tr '/' ' ')
  local last_directory
  last_directory=$(basename "$PWD")
  local new_path=""
  for directory in ${directories}; do
    if [[ $directory == "$last_directory" ]]; then
      new_path+="/$directory"
    else
      new_path+="/$(echo "$directory" | head -c1)"
    fi
  done
  if [[ $new_path == "" ]]; then
    new_path="/"
  fi
  printf "%s%s" "$GREEN" "$new_path"
}

function __count_dirs_stack()
{
  local dirs_count="$1"
  if [[ $dirs_count != "" ]]; then
    if [[ $dirs_count != 1 ]]; then
      printf "[%sd%s%s]" "$ORANGE" "$dirs_count" "$GREEN"
    fi
  fi
}

function __count_jobs_stack()
{
  local jobs_count="$1"
  if [[ $jobs_count != "" ]]; then
    if [[ $jobs_count != 0 ]]; then
      printf "[%sj%s%s]" "$VIOLET" "$jobs_count" "$GREEN"
    fi
  fi
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
    printf ", %s%s%s" "$WHITE" "$git_tag" "$YELLOW"
  fi
}

function __git_modifications_prompt()
{
  __modified_files_count
  git_count=$(git diff --word-diff 2> /dev/null)
  if [[ ${git_count} != "" ]]; then
    git_diff_word=$(echo "$git_count" | grep '\[-.*-\]\|{+.*+}')
    if [[ ${git_diff_word} != "" ]]; then
      printf ","
      change_rows=$(echo "${git_diff_word}" | grep -c '\[-.*-\]{+.*+}')
      if [[ ${change_rows} != "0" ]]; then
        printf " %s~%s" "$YELLOW" "$change_rows"
      fi
      plus_rows=$(echo "${git_diff_word}" | grep -cv '\[-.*-\]')
      if [[ ${plus_rows} != "0" ]]; then
        printf " %s+%s" "$GREEN" "$plus_rows"
      fi
      minus_rows=$(echo "${git_diff_word}" | grep -cv '{+.*+}')
      if [[ ${minus_rows} != "0" ]]; then
        printf " %s-%s" "$RED" "$minus_rows"
      fi
    fi
    printf "%s" "$YELLOW"
  fi
}

function __modified_files_count()
{
  git_status=$(git status -s 2> /dev/null)
  if [[ ${git_status} != "" ]]; then
    printf ","
    added_files=$(echo "${git_status}" | grep -c '^A ')
    if [[ $added_files != 0 ]]; then
      # printf " %s✚%s" "$GREEN" "$added_files"
      printf " %s+%s" "$GREEN" "$added_files"
    fi
    deleted_files=$(echo "${git_status}" | grep -c '^\s*D')
    if [[ $deleted_files != 0 ]]; then
      # printf " %s✖%s" "$RED" "$deleted_files"
      printf " %s-%s" "$RED" "$deleted_files"
    fi
    modified_files=$(echo "${git_status}" | grep -c '^\s*M')
    if [[ $modified_files != 0 ]]; then
      # printf " %s✱%s" "$BLUE" "$modified_files"
      printf " %s~%s" "$BLUE" "$modified_files"
    fi
    renamed_files=$(echo "${git_status}" | grep -c '^R')
    if [[ $renamed_files != 0 ]]; then
      # printf " %s➜%s" "$MAGENTA" "$renamed_files"
      printf " %s>%s" "$MAGENTA" "$renamed_files"
    fi
    unmerged_files=$(echo "${git_status}" | grep -c '^UU')
    if [[ $unmerged_files != 0 ]]; then
      # printf " %s!=%s" "$YELLOW" "$unmerged_files"
      printf " %s≠%s" "$YELLOW" "$unmerged_files"
    fi
    untraced_files=$(echo "${git_status}" | grep -c '^??')
    if [[ $untraced_files != 0 ]]; then
      # printf " %s◼%s" "$WHITE" "$untraced_files"
      printf " %s?%s" "$WHITE" "$untraced_files"
    fi
    printf "%s" "$YELLOW"
  fi
}

function __git_commit_status()
{
  git_commit_status=$(git status -uno 2> /dev/null | grep -i 'Your branch' | grep -Eo 'by [0-9]+|diverged|behind|ahead')
  if [[ ${git_commit_status} != "" ]]; then
    printf ", %s" "$VIOLET"
    if [[ $(echo "$git_commit_status" | grep -Eo 'ahead') != "" ]]; then
      # printf "⬆"
      printf "^"
    elif [[ $(echo "$git_commit_status" | grep -Eo 'behind') != "" ]]; then
      # printf "⬇"
      printf "v"
    elif [[ $(echo "$git_commit_status" | grep -Eo 'diverged') != "" ]]; then
      # local_remote=$(git status -uno | grep -Eo 'and have [0-9]+ and [0-9]+' | sed -e 's/.\+\([[:digit:]]\+\) and \([[:digit:]]\+\)/\1⬆ \2⬇/')
      local_remote=$(git status -uno | grep -Eo 'and have [0-9]+ and [0-9]+' | sed -e 's/.\+\([[:digit:]]\+\) and \([[:digit:]]\+\)/\1^ \2v/')
      # local_remote=$(git status -uno | grep -Eo 'and have [0-9]+ and [0-9]+' | sed -e 's/.\+ \([[:digit:]]\+\) and \([[:digit:]]\+\)/\1 \2/')
      printf "(%s)" "$local_remote"
    fi
    number_of_commits=$(echo "$git_commit_status" | grep -Eo '[0-9]+')
    printf "%s%s" "$number_of_commits" "$YELLOW"
  fi
}

function __git_stash_count()
{
  git_stash_count=$(git stash list 2> /dev/null | wc -l)
  if [[ ${git_stash_count} != "0" ]]; then
    # printf ", %s✭%s%s" "$ORANGE" "$git_stash_count" "$YELLOW"
    printf ", %s*%s%s" "$ORANGE" "$git_stash_count" "$YELLOW"
  fi
}

__prompt_command "$@"
