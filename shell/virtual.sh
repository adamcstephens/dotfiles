# docker
alias drm='docker rm'
alias dps='docker ps -a'

#
# lxc
alias lxca='sudo lxc-ls --active'

#
# vagrant
alias vdestroy='vagrant destroy '
alias vp='vagrant provision'
alias vs='vagrant status'
alias vsg='vagrant global-status'
alias vup='vagrant up'
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
# virtualbox
alias vb=VBoxManage
