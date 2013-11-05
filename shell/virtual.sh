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
