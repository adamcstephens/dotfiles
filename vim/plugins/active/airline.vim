" enable status bar always
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
