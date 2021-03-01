#!/usr/bin/env bash
# Source: https://codingnest.com/how-to-use-gpg-with-yubikey-wsl/

SOCAT_PID_FILE=$HOME/.cache/wsl-gpg.pid

if [[ -f $SOCAT_PID_FILE ]] && kill -0 $(cat $SOCAT_PID_FILE) &>/dev/null; then
  : # already running
else
  echo "Starting gpg-agent relay."
  rm -f "$HOME/.gnupg/S.gpg-agent"
  (trap "rm $SOCAT_PID_FILE" EXIT; socat UNIX-LISTEN:"$HOME/.gnupg/S.gpg-agent,fork" EXEC:'/mnt/c/ProgramData/chocolatey/lib/npiperelay/tools/wsl-relay.exe --input-closes --pipe-closes --gpg',nofork </dev/null &>/dev/null) &
  echo $! >$SOCAT_PID_FILE
fi
