" Change the leader map
let g:mapleader = ','

":1 Shortcuts to rapidly set value
nmap <leader>, :execute 'set number! foldcolumn=' . (!&foldcolumn * 4)<CR>
nmap <leader>f :set foldmethod=indent<CR>
nmap <leader>m :set foldmethod=marker<CR>
nmap <leader>l :set list!<CR>
nmap <leader>r :set wrap!<CR>
" endfold

":1 Move between windows
nmap <leader>d <C-w><LEFT>
nmap <leader>n <C-w><RIGHT>
nmap <leader>t <C-w><UP>
nmap <leader>h <C-w><DOWN>

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

" Easy fold toggle
nmap e za

" Easy fold toggle (fix for `quickfix` filetype)
autocmd vimrc BufEnter * if &filetype == 'qf' |unmap <CR>|    endif
autocmd vimrc BufEnter * if &filetype != 'qf' | nmap <CR> za| endif

" Easy indent
nmap > >>
nmap < <<

" Easy join lines
noremap gj gJ

" Save file
" Need 'stty -ixon' command in shell (CLI).
" more: http://superuser.com/questions/227588/vim-command-line-imap-problem
nmap <C-s> :w!<CR>
imap <C-s> <ESC>:w!<CR>

" Close buffer
nmap <C-b> :close<CR>
imap <C-b> <ESC>:close<CR>

" Window tab
nmap <C-t> :tabnew<CR>
