" This file is for:
" 1. not decided where to put the code
" 2. ugly codes that need refactor

":1 Dvorak: 'hjkl' change
" left, down, up, right
noremap d <left>
noremap h g<down>
noremap t g<up>
noremap n <right>

" delete text (was: move down)
noremap j d
" disabled    (was: move up)
noremap k <nop>

" up, down leap
noremap H 6g<Down>
noremap T 6g<Up>

":1 Dvorak: mappings
" Goto line beginning
noremap _ ^

" Goto line end
noremap - $

" To command line mode
noremap s :
noremap S :

" Search next (was: move to right character)
noremap l n

" Search prev (was: move to up line)
noremap L N

":1 Dvorak: NERDTree
let g:NERDTreeMapOpenInTab = '<C-S-t>'
let g:NERDTreeMapOpenInTabSilent='<C-S-D>'
" endfold

" Identify the syntax hightlighting group used at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Highlight over length lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929

":1 :SourcePrint
function! g:SourcePrint()
  colo macvim
  set background=light
  TOhtml
  w! ~/vim-source.html
  bdelete!
  !open ~/vim-source.html
  color jellybeans
  set background=dark
endfunction

command! SourcePrint :call g:SourcePrint()

":1 :ProseMode
function! ProseMode()
  call goyo#execute(0, [])
  set nocopyindent
  set nosmartindent noai nolist noshowmode noshowcmd
  set complete+=s
endfunction

command! ProseMode call ProseMode()
