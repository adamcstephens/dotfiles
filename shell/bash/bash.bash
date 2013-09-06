if which brew > /dev/null 2>&1
then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
  fi
fi

COLORRESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"

if [ -f /usr/share/git/completion/git-prompt.sh ]
then
  source /usr/share/git/completion/git-prompt.sh
fi

if declare -f __git_ps1 > /dev/null 2>&1
then
  export PS1="${GREEN}\u@\h ${YELLOW}\w${RED}\$(__git_ps1) ${COLORRESET}❯ "
else
  export PS1="${GREEN}\u@\h ${YELLOW}\w ${COLORRESET}❯ "
fi
export PROMPT_COMMAND='echo -ne "\033]0;@${HOSTNAME}\007"'

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=1
export GIT_PS1_SHOWCOLORHINTS=1

if [ -f ~/.bashrc ]; then
     source ~/.bashrc
fi
