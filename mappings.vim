" Change the leader map
let g:mapleader = ','
let g:maplocalleader = ','

" Shortcut to toggle line number
nmap <leader>, :execute 'set number! foldcolumn=' . (!&foldcolumn * 4)<CR>

" Shortcut to fold method change
nmap <leader>f :set foldmethod=indent<CR>
nmap <leader>m :set foldmethod=marker<CR>

" Shortcut to rapidly toggle 'set list'
nmap <leader>l :set list!<CR>

" Shortcut to rapidly toggle 'set wrap'
nmap <leader>r :set wrap!<CR>

" Easy indent
nmap > >>
nmap < <<

" Easy ESC (compatible with LeaveInsert)
imap <C-c> <ESC>

" Save file
" Need 'stty -ixon' command in shell (CLI).
" more: http://superuser.com/questions/227588/vim-command-line-imap-problem
nmap <C-s> :w!<CR>
imap <C-s> <ESC>:w!<CR>

" Close buffer
nmap <C-b> :close<CR>
imap <C-b> <ESC>:close<CR>

" Window move
nmap <leader>d <C-w><LEFT>
nmap <leader>n <C-w><RIGHT>
nmap <leader>t <C-w><UP>
nmap <leader>h <C-w><DOWN>

":1 Window tab settings
nnoremap gk gt
nmap <C-t> :tabnew<CR>
map <M-1> 1gk
map <M-2> 2gk
map <M-3> 3gk
map <M-4> 4gk
map <M-5> 5gk
map <M-6> 6gk
map <M-7> 7gk
map <M-8> 8gk
map <M-9> 9gk

if system('uname') =~# 'Darwin'
  map <D-1> 1gk
  map <D-2> 2gk
  map <D-3> 3gk
  map <D-4> 4gk
  map <D-5> 5gk
  map <D-6> 6gk
  map <D-7> 7gk
  map <D-8> 8gk
  map <D-9> 9gk
endif

":1 Keymap switch
let g:current_keymap = ''
function! g:ToggleKeymap()
  if g:current_keymap ==# ''
    set keymap=mongolian-dvorak
    let g:current_keymap = 'mongolian-dvorak'
  else
    set keymap=""
    let g:current_keymap = ''
  endif
endfunction

imap <C-l> <ESC>:call ToggleKeymap()<CR>a
 map <C-l>      :call ToggleKeymap()<CR>
imap <F8>  <ESC>:call ToggleKeymap()<CR>a
 map <F8>       :call ToggleKeymap()<CR>
