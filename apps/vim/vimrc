set nocompatible
set modelines=2
set nu

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" modify delays
set timeoutlen=1000
set ttimeoutlen=0

set encoding=utf-8

" set a leader!
:let mapleader="f"

" toggle the gutter
function! ToggleGutters()
  :set invnumber
  :GitGutterToggle
  :ALEToggle
endfunction
map <Leader>g :call ToggleGutters()<CR>

" don't create stupid files
set nobackup
set noundofile

" allow all backspace in insert
:set backspace=indent,eol,start

" jump to last position when re-opening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
" except for git commits
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

" fix my damn inability to type
command Qa qa
command Q q

" shortcuts
nnoremap <Leader>d :bdelete<CR>
nnoremap <Leader>D :bdelete!<CR>
nnoremap <Leader>p :set invpaste<CR>
map <Leader>w :write<CR>

" keep buffer undo when switching
set hidden

" close netrw
autocmd FileType netrw setl bufhidden=wipe

nnoremap <Leader>s :set hlsearch!<CR>

" highlight unwanted chars
set list
set listchars=tab:»·,trail:·,nbsp:·

" enable mouse
set mouse=
set ttymouse=

" set colorcolumn
set colorcolumn=100

" let g:ansible_name_highlight = 'b'
" disable vim-json's quite hiding
" let g:vim_json_syntax_conceal = 0

" ale
" turn off background highlighting in favor of gutter only
let g:ale_linters = { 'ruby': ['standardrb'] }
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'], 'ruby': ['standardrb'] }
let g:ale_fix_on_save = 1
let g:ale_set_highlights = 0
let g:ale_puppet_puppetlint_options = '--no-80chars-check --no-class_inherits_from_params_class-check --no-variable_scope-check --no-documentation-check --no-autoloader_layout-check'
let g:ale_python_flake8_options = '--ignore=E501,E221,E251'
let g:ale_sh_shellcheck_exclusions = 'SC2039'
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: {max: 1200}}}"'
nmap <silent> <Leader>j <Plug>(ale_previous_wrap)
nmap <silent> <Leader>k <Plug>(ale_next_wrap)

" fzf
" act like ctrl-p
nnoremap <c-p> :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <silent> <Leader>K :Ag "\b<C-R><C-W>\b"<CR>
" preview
let g:fzf_files_options =
      \ '--reverse ' .
      \ '--preview-window top:60% ' .
      \ '--preview "(bat --color "always" {} || cat {}) 2> /dev/null | head -'
      \ . &lines . '"'

" gitgutter
" reduce update time from 4s
set updatetime=100

" indentline
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_first_char = '▏'
let g:indentLine_char = '▏'

" lightline
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'OldHope',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" markdown
let g:vim_markdown_conceal = 0

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" allow quit if nerdtree is only open buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" open nerdtree if no files
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" qf-resize
let g:qf_resize_min_height = 10
let g:qf_resize_max_height = 30
let g:qf_resize_max_ratio = 0.30

" rooter
let g:rooter_silent_chdir = 1

" must run after loaded
syntax on
filetype plugin indent on

let darkstate = 0
let darkstatefile = glob('~/.dotfiles/.dark-mode.state')
if filereadable(expand(darkstatefile))
  let darkstatefilestate = readfile(darkstatefile)

  if darkstatefilestate[0] == "false"
    let darkstate = 1
  endif
endif
set termguicolors
if darkstate != 0
  silent! colorscheme default
else
  silent! colorscheme old-hope
endif
highlight Comment cterm=italic gui=italic

set cursorline

" catalina defaults to internal, but doesn't support it :(
if &diff
    set diffopt-=internal
    set diffopt+=vertical
endif
