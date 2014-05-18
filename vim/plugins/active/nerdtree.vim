" nerdtree
map <C-n> :NERDTreeToggle<CR>
" allow quit if nerdtree is only open buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

