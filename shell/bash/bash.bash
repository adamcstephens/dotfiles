if which brew > /dev/null 2>&1
then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
  fi
fi

export PS1='\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\$ '
export PROMPT_COMMAND='echo -ne "\033]0;@${HOSTNAME}\007"'
