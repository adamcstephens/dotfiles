# puppet file
alias pl='puppet-lint --no-80chars-check --no-class_inherits_from_params_class-check --no-variable_scope-check --no-documentation-check --no-autoloader_layout-check --with-filename'
alias pp='puppet parser validate'
function pes() {
  [ -z $1 ] && return 1
  erb -P -x -T '-' $1 | ruby -c
}
