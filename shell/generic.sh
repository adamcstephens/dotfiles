export CLICOLOR=''
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;32'
export PAGER='less -rFX'
export EDITOR='vim'

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

# debian
alias acsh="aptitude show"
# crypt
alias mountcrypt="encfs $HOME/backup/encrypted $HOME/decrypted/"
alias umountcrypt="fusermount -u $HOME/decrypted"

# fresh
source ~/.fresh/build/shell.sh

# linux
alias linsleep='sudo pm-suspend'

# debian
alias acsh='apt-cache show'

# notes
alias cln="cat ~/notes/\`ls -1t ~/notes | head -n1\`"

#function aln {
#  fc -l $1 $1 >> 
#}
alias eln="vim ~/notes/\`ls -1t ~/notes | head -n1\`"
function elng {
  filename=`grep -H "$1" ~/notes/* | cut -f1 -d\: | sort -u | head -n1`
  if [ -e $filename ]
  then
    vim $filename
  else
    echo "no note found"
  fi
}
alias nn="vim ~/notes/\`date +%Y-%m-%d_%H%M\`.txt"
function nnn {
  vim ~/notes/$1.txt
}
alias lnn="ls -lt ~/notes"
alias lln="ls -1 ~/notes/\`ls -1t ~/notes | head -n1\`"

# pyenv
if [ -d $HOME/.pyenv/shims ]
then
  export PATH="$PATH:$HOME/.pyenv/shims"
fi
if [ -d $HOME/.pyenv/bin ]
then
  export PATH="$PATH:$HOME/.pyenv/bin"
fi
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init -)"; fi

# python
if python -V 2>&1 | grep -q 2.4
then
  if which python26 > /dev/null
  then
    alias python=python26
  fi
fi

# rbenv
if [ -d $HOME/.rbenv/shims ]
then
  export PATH="$PATH:$HOME/.rbenv/shims"
fi
if [ -d $HOME/.rbenv/bin ]
then
  export PATH="$PATH:$HOME/.rbenv/bin"
fi
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init -)"; fi

# set up ruby libs
export RUBYLIB=~/.fresh/source/github/hub/lib

# ssh
function delkey {
  [ -z $1 ] && echo "supply deletion key" && return 2
  sed -i -e "/.*$1/d" ~/.ssh/known_hosts
}

# vagrant/veewee
alias vdestroy='vagrant destroy '
alias veewee='bundle exec veewee'
alias vf='veewee fusion'
alias vs='vagrant status'
alias vv='veewee vbox'
function vssh {
  vmName=$1

  if ! vagrant status $vmName | grep 'running (' 
  then
    vagrant up $vmName
  fi
  vagrant ssh $vmName
}
function vreload {
  vmName=$1
  vagrant destroy -f $vmName
  vssh $vmName
}

function bootstrap_rbenv {
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
}
