"
" plugins
"
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
Plug 'sheerun/vim-polyglot'
Plug 'sirver/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/molokai'
Plug 'w0rp/ale'
Plug 'whatyouhide/vim-lengthmatters'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" let g:ansible_name_highlight = 'b'
" let g:terraform_align=1
" disable vim-json's quite hiding
" let g:vim_json_syntax_conceal = 0

" ag.vim
" Use ag over grep
set grepprg=ag\ --nogroup\ --nocolor

" airline
set laststatus=2
" set a theme
let g:airline_theme="simple"
" show buffer bar
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" add the date/time to the gutter
let g:airline_section_gutter = '%= %{strftime("%R")}'
" use powerline fonts if available
let g:airline_powerline_fonts = 1

" ale
" turn off background highlighting in favor of gutter only
let g:ale_set_highlights = 0
let g:ale_puppet_puppetlint_options = '--no-80chars-check --no-class_inherits_from_params_class-check --no-variable_scope-check --no-documentation-check --no-autoloader_layout-check'
let g:ale_python_flake8_options = '--ignore=E501,E221,E251'
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: {max: 1200}}}"'

" deoplete
"let g:deoplete#enable_at_startup = 1

" fzf
" act like ctrl-p
nnoremap <c-p> :FZF<cr>
nnoremap <Leader>b :Buffers<cr>

" LanguageClient
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
" let g:LanguageClient_serverCommands = {
"     \ 'ruby': [ 'solargraph', 'stdio' ],
"     \ }
" nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" length highlighting
let g:lengthmatters_start_at_column = 101
let g:vim_markdown_folding_disabled=1

" snippets
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" test
nmap <Leader>r :TestNearest<CR>
nmap <Leader>R :TestFile<CR>
