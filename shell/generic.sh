#alias ll='ls -l'
alias pwgen='curl -k -3 https://mail.drh.net/cgi-bin/get_password.cgi'
alias tree='tree -C'
alias veewee='bundle exec veewee'
alias vf='veewee fusion'
alias vs='vagrant status'
alias vv='veewee vbox'
alias vundle_update='vim +BundleInstall +qall'
alias synckvm='rsync -av ~/projects/greenarrow-integration/ kvm:/opt/greenarrow-integration/'

if [ -d $HOME/.rbenv ]
then
  export PATH="$PATH:$HOME/.rbenv/shims"
fi
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init -)"; fi

# fresh
source ~/.fresh/build/shell.sh

export CLICOLOR=''
export PAGER='less -rFX'


#vagrant stuff
alias vdestroy='vagrant destroy '
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

function delkey {
  sed -i -e "/.*$1/d" ~/.ssh/known_hosts
}

# my sublime text customizations
#export EDITOR='subl -w'
alias subl="'/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl' "
