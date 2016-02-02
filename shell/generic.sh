[ -e $HOME/.shell_local.sh ] && . $HOME/.shell_local.sh

# _generic
if ls --color=auto > /dev/null 2>&1
then
  alias ls="ls --color=auto"
fi
alias ll="ls -l"
alias l="ls -la"
alias l1h="ls -1t | head"
alias scat="egrep -v '^(\s*)?(#|$)' "

# shell
function esl {
  if [ ! -z $ZSH_NAME ]
  then
    exec $ZSH_NAME -l
  else
    exec $SHELL -l
  fi
}
alias esl="exec $SHELL -l"

alias tree='tree -FC'
alias vundle_update='vim +BundleUpdate +BundleClean! +qall'

# ssh
function delkey {
  [ -z $1 ] && echo "supply deletion key" && return 2
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R $1
}
