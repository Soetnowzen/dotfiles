function do_bash_run {
  if (( _bash_runner_pid == 0 )); then
    echo "Starting bash runner"
    mkfifo $_bash_runner_inpipe $_bash_runner_outpipe
    chmod 700 $_bash_runner_inpipe $_bash_runner_outpipe

    /bin/bash $ZSHHOME/conf/runner.bash $_bash_runner_inpipe $_bash_runner_outpipe ${HOME}/.bashrc &!
    _bash_runner_pid=$!
    echo $_bash_runner_pid >! $_bash_runner_lock
  fi

  echo "$@" > $_bash_runner_inpipe && cat $_bash_runner_outpipe
}

# Run anything in bash
function b {
  do_bash_run r $PWD $@
}

function bashrun_cleanup {
  echo "Cleaning up bash runner ${_bash_runner_pid}"

  if (( _bash_runner_pid > 0 )); then
    kill -KILL "$_bash_runner_pid" &>/dev/null
    _bash_runner_pid=0
  fi

  rm -f $_bash_runner_inpipe
  rm -f $_bash_runner_outpipe
  rm -f $_bash_runner_lock
}

function bashrun_setup {
  _bash_runner_pid=0
  _bash_runner_lock=$(mktemp "${TMPDIR}/bashrun_server-XXXXXXXXXX")
  _bash_runner_inpipe=${_bash_runner_lock}.in
  _bash_runner_outpipe=${_bash_runner_lock}.out

  # Load required functions.
  autoload -Uz add-zsh-hook

  add-zsh-hook zshexit bashrun_cleanup

#  alias exec='bashrun_cleanup ; exec'
}


bashrun_setup "$@"

