#alias git=hub
#function git(){hub $@}
#alias ga='git add'
#alias gbv='git branch -av'
#alias gc='git commit'
#alias gd='git diff'
#alias gp='git push'
#alias gs='git status'
alias ll='ls -l'
alias pwgen='curl -k -3 https://mail.drh.net/cgi-bin/get_password.cgi'
alias tree='tree -C'
alias veewee='bundle exec veewee'
alias vf='veewee fusion'
alias vs='vagrant status'
alias vv='veewee vbox'
alias vundle_update='vim +BundleInstall +qall'
alias synckvm='rsync -av ~/projects/greenarrow-integration/ kvm:/opt/greenarrow-integration/'
export PATH="$PATH:$HOME/bin:$HOME/.rbenv/shims:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin"

export CLICOLOR=''
export PAGER='less -rFX'

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
#alias vssh='vagrant ssh'
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
  gsed -i "/.*$1/d" ~/.ssh/known_hosts
}

# my sublime text customizations
#export EDITOR='subl -w'
alias subl="'/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl' "

# vim: set ft=sh
