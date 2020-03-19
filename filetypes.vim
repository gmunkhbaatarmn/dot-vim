":1 FileType: Ruby
Plugin 'vim-ruby/vim-ruby'

" Improve rendering speed
let g:ruby_no_expensive = 1

autocmd vimrc BufEnter * if &filetype == 'ruby' |
      \ nmap <F5>   :w<CR>:!time ruby "%"             <CR>|endif

autocmd vimrc BufEnter * if &filetype == 'ruby' |
      \ nmap <S-F5> :w<CR>:!time ruby "%" < input.txt <CR>|endif
