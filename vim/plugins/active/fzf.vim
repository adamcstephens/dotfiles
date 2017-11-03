Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'

" act like ctrl-p
nnoremap <c-p> :FZF<cr>
nnoremap <Leader>b :Buffers<cr>
