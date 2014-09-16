" ------------------------------
" Dvorak specific config for vim
" ------------------------------

" Dvorak: 'hjkl' change
noremap d h
noremap h j
noremap t k
noremap n l
noremap j d
noremap k t
noremap l n
noremap L N
noremap H 6<Down>
noremap T 6<Up>
nnoremap gh gj
nnoremap gt gk

" Dvorak: For productivity
noremap s :
noremap S :
noremap - $
noremap _ ^

" Dvorak: NERDTree
let g:NERDTreeMapOpenInTab = '<C-S-t>'
let g:NERDTreeMapOpenInTabSilent='<C-S-D>'
