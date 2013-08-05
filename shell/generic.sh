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
alias gt='git tag -l'

# notes
alias cln="cat ~/notes/\`ls -1t ~/notes | head -n1\`"
alias eln="vim ~/notes/\`ls -1t ~/notes | head -n1\`"
function elng {
  filename=`grep "$1" ~/notes/* | cut -f1 -d\: | sort -u`
  vim $filename
}
alias nn="vim ~/notes/\`date +%Y-%m-%d_%k%M\`.txt"
alias lnn="ls -lt ~/notes"

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
