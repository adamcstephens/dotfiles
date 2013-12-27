# puppet file
alias pp='puppet parser validate'
function pes() {
  [ -z $1 ] && return 1
  erb -P -x -T '-' $1 | ruby -c
}
