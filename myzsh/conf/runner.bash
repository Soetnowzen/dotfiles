#!/bin/bash

INPIPE=$1
OUTPIPE=$2
RCFILE=$3

set --

trap "echo clean up; rm -f $INPIPE $OUTPIPE" EXIT

export TOP_PID=$$

if [ -f $RCFILE ]; then
  source $RCFILE
fi

while true; do
echo "Bash runner ($TOP_PID) ready"
read -r -a cmd <$INPIPE
{
  echo "** ${cmd[@]} **"
  case "${cmd[0]}" in
    d) date ;;
    r) cd ${cmd[1]} &&
       eval "${cmd[@]:2}" ;;
    q) echo "bye"
       kill -s EXIT $TOP_PID ;;
    *) echo "What?" ;;
  esac
} 2>&1 1>$OUTPIPE
done

