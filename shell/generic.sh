export CLICOLOR=''
export PAGER='less -rFX'

# _generic
alias esl="exec $SHELL -l"
alias pwgen='curl -k -3 https://mail.drh.net/cgi-bin/get_password.cgi'
alias tree='tree -C'
alias vundle_update='vim +BundleInstall +qall'

# fresh
source ~/.fresh/build/shell.sh

# git
alias gbv='git branch -av'
alias gs='git status' 

# rbenv
if [ -d $HOME/.rbenv ]
then
  export PATH="$PATH:$HOME/.rbenv/shims"
fi
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init -)"; fi

# ssh
function delkey {
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
