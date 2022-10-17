#!/bin/bash

function tmux-session-saver()
{
	SESSIONNAME="script"
	tmux has-session -t $SESSIONNAME &> /dev/null

	if [[ $? != 0 ]]; then
		tmux new-session -s $SESSIONNAME -n script -d
		tmux send-keys -t $SESSIONNAME "$HOME/bin/script" C-m
	fi

	tmux attach -t $SESSIONNAME
}
