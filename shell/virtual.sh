# docker
alias drm='docker rm'
alias dps='docker ps -a'
# virtualbox
alias vb=VBoxManage
# vagrant
alias vdestroy='vagrant destroy '
alias vp='vagrant provision'
alias vs='vagrant status'
alias vup='vagrant up'
#alias veewee='bundle exec veewee'
#alias vf='veewee fusion'
#alias vv='veewee vbox'
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

#
# lxc
alias lxca='sudo lxc-ls --active'
