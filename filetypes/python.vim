autocmd vimrc BufEnter .flake8
  \   setlocal filetype=cfg

autocmd vimrc FileType python
  \ nmap <buffer> <F5>   :w<CR>:!time python '%'            <CR>
autocmd vimrc FileType python
  \ nmap <buffer> <S-F5> :w<CR>:!time python '%' < '%:r.txt'<CR>
autocmd vimrc FileType python
  \ nmap <buffer> <F9>   :w<CR>:!flake8 --show-source --select F,E999 '%'<CR>
autocmd vimrc FileType python
  \ nmap <buffer> <S-F9> :w<CR>:!flake8 --show-source --select F,E999,I001,I003 '%'<CR>
