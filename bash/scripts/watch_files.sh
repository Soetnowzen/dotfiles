#!/bin/bash -e

function watch_files()
{

  command_to_run="$1"
  shift
  files_to_watch=$@
  num_files=$#

  changed_times() {
    for file in ${files_to_watch}; do
      if ! stat -c %Z "$file"; then
        echo "File not found: \"$file\""
        exit 1
      fi
    done
  }

declare -a last_changed=($(changed_times))

doit() {
  local i

  while true; do
    current_changed=($(changed_times))
    has_changed=0

    for i in $(seq 0 $((num_files - 1))); do
      if [ "${last_changed[i]}" != "${current_changed[i]}" ]; then
        has_changed=1
        break
      fi
    done

    if [ ${has_changed} -eq 1 ]; then
      echo "### File changed, running command ###"
      set +e
      eval "${command_to_run}"
      exit_code=$?
      set -e
      echo "### Running command DONE"
      echo "###   EXIT CODE = ${exit_code}"
      echo -e "\n"
    fi

    last_changed=($(changed_times))

    sleep 2
  done
}

doit
}
