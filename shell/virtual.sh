# docker
alias di='docker images '
alias dk='docker kill '
alias drm='docker rm '
alias drmi='docker rmi '
alias dps='docker ps '

#
# lxc
alias lxca='sudo lxc-ls --active'

#
# vagrant
alias vdestroy='vagrant destroy '
alias vp='vagrant provision '
alias vs='vagrant status '
alias vsg='vagrant global-status '
alias vup='vagrant up '
alias vssh='vagrant ssh '
function vreload {
  vmName=$1
  vagrant destroy -f $vmName
  vup $2 $vmName
  vssh $vmName
}

#
# virtualbox
alias vb=VBoxManage
