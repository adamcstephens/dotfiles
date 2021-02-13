#!/usr/bin/env bash
# Source: https://stuartleeks.com/posts/wsl-ssh-key-forward-to-windows/

# Configure ssh forwarding
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
# need `ps -ww` to get non-truncated command for matching
# use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
SOCAT_PID_FILE=$HOME/.cache/wsl-ssh.pid

if [[ -f $SOCAT_PID_FILE ]] && kill -0 $(cat $SOCAT_PID_FILE); then
  : # already running
else
  if [[ -S $SSH_AUTH_SOCK ]]; then
      # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
      echo "removing previous socket..."
      rm $SSH_AUTH_SOCK
  fi
  echo "Starting ssh-agent relay."
  # setsid to force new session to keep running
  # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
  (trap "rm $SOCAT_PID_FILE" EXIT; socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/ProgramData/chocolatey/lib/npiperelay/tools/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &>/dev/null) &
  echo $! >$SOCAT_PID_FILE
fi
