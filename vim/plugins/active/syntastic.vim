" syntastic

" pending neomake being better: if !has('nvim')
Plug 'scrooloose/syntastic'
let g:syntastic_puppet_puppetlint_args='--no-80chars-check --no-class_inherits_from_params_class-check --no-variable_scope-check --no-documentation-check --no-autoloader_layout-check'
"endif
