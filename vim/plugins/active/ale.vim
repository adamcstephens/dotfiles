Plug 'w0rp/ale'

let g:ale_puppet_puppetlint_options = '--no-80chars-check --no-class_inherits_from_params_class-check --no-variable_scope-check --no-documentation-check --no-autoloader_layout-check'
let g:ale_python_flake8_options = '--ignore=E501,E221,E251'
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: {max: 1200}}}"'
