# shorten long paths
export PROMPT_DIRTRIM=2

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


MY_COLORRESET="\[\033[0m\]"
MY_RED="\[\033[0;31m\]"
MY_GREEN="\[\033[0;32m\]"
MY_BROWN="\[\033[0;33m\]"
MY_BLUE="\[\033[0;34m\]"
MY_PURPLE="\[\033[0;35m\]"
MY_CYAN="\[\033[0;36m\]"
MY_LTGRAY="\[\033[0;37m\]"

MY_DKGRAY="\[\033[1;30m\]"
MY_LTRED="\[\033[1;31m\]"
MY_LTGREEN="\[\033[1;32m\]"
MY_YELLOW="\[\033[1;33m\]"
MY_LTBLUE="\[\033[1;34m\]"
MY_LTPURPLE="\[\033[1;35m\]"
MY_LTCYAN="\[\033[1;36m\]"
MY_WHITE="\[\033[1;37m\]"


if [ -f /usr/share/git/completion/git-prompt.sh ] # archlinux
then
  source /usr/share/git/completion/git-prompt.sh
elif [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ] # centos
then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

if [[ $USER == 'root' ]]
then
  USERSTRING="${MY_LTRED}\u"
elif [[ $USER == 'adam' || $USER == 'adam.c.stephens' ]]
then
  USERSTRING="${MY_GREEN}"
else
  USERSTRING="${MY_GREEN}\u"
fi

if declare -f __git_ps1 > /dev/null 2>&1
then
  MYGITPROMPT="${MY_PURPLE}\$(__git_ps1)"
else
  MYGITPROMPT=''
fi
export PS1="${USERSTRING}@\h ${MY_BROWN}\w${MYGITPROMPT} ${MY_CYAN}❯${MY_COLORRESET} "
if [[ $TERM =~ xterm.* ]]
then
  export PROMPT_COMMAND='echo -ne "\033]0;@${HOSTNAME}\007"'
fi

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=1
export GIT_PS1_SHOWCOLORHINTS=1

# fzf
[[ -e ~/.fzf.bash ]] && source ~/.fzf.bash
