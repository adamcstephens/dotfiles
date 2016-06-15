let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_yaml_yamllint_args='-d "{extends: relaxed, rules: {line-length: {max: 1200}}}"'
