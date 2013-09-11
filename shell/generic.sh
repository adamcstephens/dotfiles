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

# debian
alias acs="apt-cache search"
alias acsh="apt-cache show"
alias adg="sudo apt-get update && sudo apt-get dist-upgrade"
alias ai="sudo apt-get install"

# fresh
source ~/.fresh/build/shell.sh

# git
alias ga='git add'
alias gbv='git branch -av'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull'
alias glo='git log --oneline'
alias gp='git push'
alias gs='git status' 
alias gss='git status --short' 
alias gt='git tag -l'

# notes
alias cln="cat ~/notes/\`ls -1t ~/notes | head -n1\`"
alias eln="vim ~/notes/\`ls -1t ~/notes | head -n1\`"
function elng {
  filename=`grep "$1" ~/notes/* | cut -f1 -d\: | sort -u`
  vim $filename
}
alias nn="vim ~/notes/\`date +%Y-%m-%d_%H%M\`.txt"
alias lnn="ls -lt ~/notes"

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
