export CLICOLOR=''
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;32'
export PAGER='less -rFX'
export EDITOR='vim'

which colordiff &>/dev/null && alias diff=colordiff

[ -e $HOME/.shell_local.sh ] && . $HOME/.shell_local.sh

# _generic
if ls --color=auto > /dev/null 2>&1
then
  alias ls="ls --color=auto"
fi
alias ll="ls -l"
alias l="ls -la"
alias esl="exec $SHELL -l"
alias fesl="fresh && esl"
alias fuesl="fresh update && esl"
alias pwgen='curl -k -3 https://mail.drh.net/cgi-bin/get_password.cgi'
alias tree='tree -C'
alias vundle_update='vim +BundleInstall +qall'

# crypt
alias mountcrypt="encfs $HOME/backup/encrypted $HOME/decrypted/"
alias umountcrypt="fusermount -u $HOME/decrypted"

# fresh
source ~/.fresh/build/shell.sh

# linux
alias linsleep='sudo pm-suspend'

# debian
alias acsh='apt-cache show'

# set up ruby libs
export RUBYLIB=~/.fresh/source/github/hub/lib

# ssh
function delkey {
  [ -z $1 ] && echo "supply deletion key" && return 2
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R $1
}
