if which brew > /dev/null 2>&1
then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
  fi
fi

COLORRESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BROWN="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
LTGRAY="\[\033[0;37m\]"

DKGRAY="\[\033[1;30m\]"
LTRED="\[\033[1;31m\]"
LTGREEN="\[\033[1;32m\]"
YELLOW="\[\033[1;33m\]"
LTBLUE="\[\033[1;34m\]"
LTPURPLE="\[\033[1;35m\]"
LTCYAN="\[\033[1;36m\]"
WHITE="\[\033[1;37m\]"


if [ -f /usr/share/git/completion/git-prompt.sh ] # archlinux
then
  source /usr/share/git/completion/git-prompt.sh
elif [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ] # centos
then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

if [[ $USER == 'root' ]]
then
  USERSTRING="${LTRED}\u"
elif [[ $USER == 'adam' ]]
then
  USERSTRING="${GREEN}"
else
  USERSTRING="${GREEN}\u"
fi

if declare -f __git_ps1 > /dev/null 2>&1
then
  MYGITPROMPT="${PURPLE}\$(__git_ps1)"
else
  MYGITPROMPT=''
fi
export PS1="${USERSTRING}@\h ${BROWN}\w${MYGITPROMPT} ${CYAN}❯${COLORRESET} "
export PROMPT_COMMAND='echo -ne "\033]0;@${HOSTNAME}\007"'

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=1
export GIT_PS1_SHOWCOLORHINTS=1

if [ -f ~/.bashrc ]; then
     source ~/.bashrc
fi
