[ -e $HOME/.shell_local.sh ] && . $HOME/.shell_local.sh

# _generic
alias grep='grep --color=auto'
alias thisweek='date +%Y-%W'

# colorize ls output
export CLICOLOR=''
export GREP_COLOR='3;32'
export PAGER='less -rFX'
if command -v nvim &> /dev/null
then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

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
function tfind {
  findfile=$1
  shift
  tree --prune -P "*$findfile*" $@
}
alias vundle_update='vim +BundleUpdate +BundleClean! +qall'

# ssh
function delkey {
  [[ -z $1 ]] && echo "supply deletion key" && return 2
  delip="$(grep ${1}\  $HOME/.ssh/known_hosts | awk '{print $1}' | cut -f 2 -d \, )"

  [[ -n $delip ]] && ssh-keygen -f "$HOME/.ssh/known_hosts" -R $delip
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R $1
}

[[ -e "$(gpgconf --list-dirs agent-socket)" ]] || gpgconf --create-socketdir
