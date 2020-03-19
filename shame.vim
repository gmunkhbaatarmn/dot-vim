" This file is for:
" 1. not decided where to put the code
" 2. ugly codes that need refactor

":1 Dvorak: Move down  (use "h" instead of "j")
map h g<down>
map H 6g<down>

" accelerate on normal mode
nmap h <Plug>(accelerated_jk_gj)
nmap H 6<Plug>(accelerated_jk_gj)

" todo: <C-h>
" todo: handle replaced command: "h" (no mapping)
" no action needed for no mapping

" todo: handle replaced command: "H" (no mapping)
" no action needed for no mapping

" todo: handle replaced key: "j" (move up)
" noremap j d

" todo: handle replaced key: "J" (join lines, minimum of two lines)
" noremap J D

":1 Dvorak: Move up    (use "t" instead of "k")
map t g<up>
map T 6g<up>

" accelerate on normal mode
nmap t <Plug>(accelerated_jk_gk)
nmap T 6<Plug>(accelerated_jk_gk)

" todo: <C-t>
" todo: help page <t>

" todo: handle replaced command: "t" (...)
" todo: handle replaced command: "T" (...)

" todo: handle replaced key: "k"
noremap k <nop>

" todo: handle replaced key: "K"
noremap K <nop>

":1 Dvorak: Move left  (use "d" instead of "h")
map d <left>

" todo: handle replaced command: "d" (...)
noremap j d

" todo: handle replaced command: "D" (...)
" todo: handle replaced key: "h"
" todo: handle replaced key: "H"

":1 Dvorak: Move right (use "n" instead of "l")
map n <right>

" todo: handle replaced command: "n" (...)
" todo: handle replaced command: "N" (...)
" todo: handle replaced key: "l"
" todo: handle replaced key: "l"
" endfold

":1 Dvorak: Mappings
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
