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
set mouse=a

" yank into the system clipboard
set clipboard=unnamed

" set colorcolumn
set colorcolumn=100

"
" plugins
"
call plug#begin('~/.vim/plugged')

"Plug 'sirver/ultisnips'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'Valloric/ListToggle'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'blueyed/vim-qf_resize'
Plug 'christoomey/vim-tmux-navigator'
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'sainnhe/sonokai'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'dense-analysis/ale'

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

" deoplete
"let g:deoplete#enable_at_startup = 1
inoremap <silent><expr><C-j> pumvisible() ? "\<c-n>" : "\<C-j>"
inoremap <silent><expr><C-k> pumvisible() ? "\<c-p>" : "\<C-k>"
inoremap <silent><expr><C-e> pumvisible() ? "\<c-y>" : "\<C-e>"

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

" LanguageClient
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
" let g:LanguageClient_serverCommands = {
"     \ 'ruby': [ 'solargraph', 'stdio' ],
"     \ }
" nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" indentline
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_first_char = '▏'
let g:indentLine_char = '▏'

" lightline
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'sonokai',
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

" snippets
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
let test#strategy = {
  \ 'nearest': 'dispatch',
  \ 'file':    'dispatch',
  \ 'suite':   'basic',
  \}
let g:dispatch_tmux_height=20

" Add plugins to &runtimepath
call plug#end()

" must run after loaded
syntax on
filetype plugin indent on

set termguicolors

let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1

silent! colorscheme sonokai
" set background=dark
highlight Comment cterm=italic gui=italic

" highlight active line
set cursorline

" catalina defaults to internal, but doesn't support it :(
if &diff
    set diffopt-=internal
    set diffopt+=vertical
endif
