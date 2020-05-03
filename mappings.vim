let g:mapleader = ','                   " Change the leader map

":1 Settings
nmap ,, :execute 'set number! foldcolumn=' . (!&foldcolumn * 4)<CR>
nmap ,f :set foldmethod=indent<CR>
nmap ,m :set foldmethod=marker<CR>
nmap ,r :set wrap!<CR>

":1 Window
" Move between windows
nmap <leader>d <C-w><LEFT>
nmap <leader>n <C-w><RIGHT>
nmap <leader>t <C-w><UP>
nmap <leader>h <C-w><DOWN>

" Open new tab
nmap <C-t> :tabnew<CR>

":1 Folding
" Easy fold toggle
nmap e za

" todo: Easy fold toggle (fix for `quickfix` filetype)
autocmd vimrc BufEnter * if &filetype == 'qf' |unmap <CR>|    endif
autocmd vimrc BufEnter * if &filetype != 'qf' | nmap <CR> za| endif

":1 Buffer
" Save buffer
" Need 'stty -ixon' command in shell (CLI).
" more: http://superuser.com/questions/227588/vim-command-line-imap-problem
nmap <C-s> :w!<CR>
imap <C-s> <ESC>:w!<CR>

" Close buffer
nmap <C-b> :close<CR>
imap <C-b> <ESC>:close<CR>

" Delete buffer
nmap <leader>b :bdelete<CR>
" endfold

":1 Keymap switch
let g:current_keymap = ''
function! g:ToggleKeymap()
  if g:current_keymap ==# ''
    set keymap=mongolian-dvorak
    let g:current_keymap = 'mongolian-dvorak'
  else
    set keymap=
    let g:current_keymap = ''
  endif
endfunction

imap <C-l> <ESC>:call ToggleKeymap()<CR>a
 map <C-l>      :call ToggleKeymap()<CR>
imap <F8>  <ESC>:call ToggleKeymap()<CR>a
 map <F8>       :call ToggleKeymap()<CR>
" endfold

":1 Dvorak: Shortcuts
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

" Easy indent
nmap > >>
nmap < <<

" Easy join lines
noremap gj gJ

" Fix for column edit
imap <C-c> <ESC>
