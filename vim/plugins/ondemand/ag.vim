Plugin 'rking/ag.vim'

let g:ctrlp_user_command = 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'

" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
