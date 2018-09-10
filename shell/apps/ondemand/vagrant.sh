#!/bin/bash
# vagrant
alias vdestroy='vagrant destroy '
alias vp='vagrant provision '
alias vpp='vp --provision-with puppet '
alias vpps='vp --provision-with puppet_server '
alias vs='vagrant status '
alias vsg='vagrant global-status '
alias vup='vagrant up '
alias vssh='vagrant ssh '
function vreload {
  vmName="$1"
  vagrant destroy -f "$vmName"
  vup "$2" "$vmName"
  vssh "$vmName"
}