let g:mapleader = ','                   " Change the leader map

":1 Settings
nmap ,, :execute 'set number! foldcolumn=' . (!&foldcolumn * 4)<CR>
nmap ,f :set foldmethod=indent<CR>
nmap ,m :set foldmethod=marker<CR>

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
nmap <CR> za

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

":1 Dvorak: NERDTree
let g:NERDTreeMapOpenInTab = '<C-S-t>'
let g:NERDTreeMapOpenInTabSilent='<C-S-D>'

":1 Dvorak: Move down  (use "h" instead of "j")
noremap h g<down>
noremap H 6g<down>

noremap <C-h> <nop>
noremap <C-H> <nop>

" - Decide lost command: "h"
" - Decide lost command: "H"
"   IGNORED

" - Use freed key: "j"
" - Use freed key: "J"
"   Easy join lines
noremap j gJ
noremap J gJ

":1 Dvorak: Move up    (use "t" instead of "k")
noremap t g<up>
noremap T 6g<up>

" - Decide lost command: "t"
" - Decide lost command: "T"
"   IGNORED

" - Use freed key: "k"
"   Delete text
noremap k d
" - Use freed key: "K"
"   Delete line
noremap K D

":1 Dvorak: Move left  (use "d" instead of "h")
noremap d <left>
noremap D b

" - Decide lost command: "d" (Delete text)
" - Decide lost command: "D" (Delete line)
"   IGNORED

" - Use freed key: "h"
"   USED AS "<down>"

" - Use freed key: "H"
"   USED AS "<down>"

":1 Dvorak: Move right (use "n" instead of "l")
noremap n <right>
noremap N w

" - Decide lost command: "n" (goto next search result)
" - Use freed key: "l"
noremap l n

" - Decide lost command: "N" (goto prev search result)
" - Use freed key: "L"
noremap L N
" endfold

" Easy indent
nmap > >>
nmap < <<

" Fix for column edit
" reference: https://stackoverflow.com/a/80761
inoremap <C-c> <Esc><Esc>
