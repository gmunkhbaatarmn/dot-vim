":1 python    Python
autocmd FileType python setlocal foldmethod=marker foldmarker=\:#,endfold

autocmd BufEnter * if &filetype == "python" |nmap <F5>   :w<CR>:!time python "%"            <CR>| endif
autocmd BufEnter * if &filetype == "python" |nmap <S-F5> :w<CR>:!time python "%" < input.txt<CR>| endif
autocmd BufEnter * if &filetype == "python" |nmap <F9>   :w<CR>:!pep8 "%"                   <CR>| endif

":1 coffee    Coffeescript
autocmd FileType coffee setlocal foldmethod=marker foldmarker=#\:,endfold

autocmd BufEnter * if &filetype == "coffee" |nmap <F5>       :w<CR>:       !coffee -c -b "%"<CR>| endif
autocmd BufEnter * if &filetype == "coffee" |nmap <C-s>      :w<CR>:silent !coffee -c -b "%"<CR>| endif
autocmd BufEnter * if &filetype == "coffee" |imap <C-s> <ESC>:w<CR>:silent !coffee -c -b "%"<CR>| endif

":1 ruby      Ruby
autocmd BufEnter * if &filetype == "ruby" |nmap <F5>   :w<CR>:!time ruby "%"            <CR>| endif
autocmd BufEnter * if &filetype == "ruby" |nmap <S-F5> :w<CR>:!time ruby "%" < input.txt<CR>| endif

":1 java      Java source file
autocmd FileType java setlocal foldmethod=marker foldmarker=BEGIN\ CUT\ HERE,END\ CUT\ HERE

autocmd BufEnter * if &filetype == "java" |nmap <F5>   :w<CR>:!javac "%"; java "%:t:r";             rm -f "%:r.class" "%:rHarness.class"<CR>| endif
autocmd BufEnter * if &filetype == "java" |nmap <S-F5> :w<CR>:!javac "%"; java "%:t:r" < input.txt; rm -f "%:r.class" "%:rHarness.class"<CR>| endif
" endif

":1 vim       Vimscript file
autocmd FileType vim setlocal foldmethod=marker foldmarker=\"\:,\"\ endfold

":1 C         C source file
autocmd BufEnter *.c nmap <F9> :w<CR>:!gcc "%" -Wall -lm -o "%:p:h/a"<CR>
" todo: autocmd BufEnter *.c nmap <F5> :w<CR>:!time ./a < input.txt<CR>
" autocmd BufEnter *.cpp nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt<CR>
autocmd BufEnter *.c nmap <F5> :w<CR>:!time ./a<CR>

":1 C++       C++ source file
autocmd BufEnter *.cpp nmap <F9> :w<CR>:!g++ "%" -Wall -o "%:p:h/a" -O3<CR>
autocmd BufEnter *.cpp nmap <F5> :w<CR>:!time "%:p:h/a"<CR>
autocmd BufEnter *.cpp nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt<CR>
autocmd BufEnter *.cpp setlocal foldmethod=marker foldmarker=\/\/\ created\:,\/\/\ end
" autocmd BufEnter *.cpp set foldmethod=marker foldmarker=\/\/\:,\/\/\ END

autocmd FileType cpp syn keyword cType string
autocmd FileType cpp syn keyword cType Vector
autocmd FileType cpp syn keyword cType Pair
autocmd FileType cpp syn keyword cType Set
autocmd FileType cpp syn keyword cType Long
autocmd FileType cpp syn keyword cType stringstream
autocmd FileType cpp syn keyword	cRepeat For Rep
autocmd FileType cpp syn match	cComment /;/

":1 PHP       PHP source file
autocmd BufEnter * if &filetype == "php" |nmap <F5> :w<CR>:!time php "%"<CR>|endif

":1 Javascript
" todo: review this
autocmd BufEnter *.js,*.json nmap <F5> :w<CR>:!time node %<CR>
autocmd BufEnter *.js,*.json nmap <F9> :w<CR>:!
      \ echo '====================================== JSHint ======================================' &&
      \ jshint "%"<CR>
autocmd BufEnter *.js,*.json setlocal foldmethod=indent textwidth=80
autocmd BufEnter *.js,*.json command! ClosureCompile :!java -jar $HOME/local/opt/closure-compiler/compiler.jar --js "%" --js_output_file "%:r".min.js
autocmd BufEnter *.js,*.json setlocal autoindent foldmarker={,} foldmethod=marker ft=javascript
let loaded_javascript_syntax_checker = 1
function! SyntaxCheckers_javascript_GetLocList()
  if exists('s:config')
    let makeprg = 'jshint ' . shellescape(expand("%")) . ' --config ' . s:config
  else
    let makeprg = 'jshint ' . shellescape(expand("%"))
  endif
  let errorformat = '%f: line %l\, col %c\, %m,%-G%.%#'
  return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

":1 HTML
" todo: htmldjango
autocmd BufEnter *.html setlocal filetype=htmldjango.html
autocmd BufEnter *.html setlocal foldmethod=marker foldmarker=#\:,endfold

":1 Stylus
" todo: stylus fix
" autocmd BufEnter *.styl nmap <F5> :w<CR>:!stylus -c "%"<CR>
" autocmd BufEnter *.styl nmap <C-s> :w<CR>:silent ! stylus -c "%"<CR>
" autocmd BufEnter *.styl imap <C-s> <ESC>:w<CR>:silent ! stylus -c "%"<CR>
autocmd BufEnter *.styl nmap <F5> :w<CR>:!stylus -c --include-css `find "%:p:h" -name "*.styl" \! -name "-*" \! -name "_*"`; find . -name '*.css' \! -name '-*' \! -name '_*' -exec csso -i {} -o {} \;<CR>
" autocmd BufEnter *.styl nmap <F9> :w<CR>:!stylus -c include-css "%"<CR>
" autocmd BufEnter *.styl nmap <C-s> :w<CR>:silent !stylus -c --include-css *.styl<CR>
" autocmd BufEnter *.styl imap <C-s> <ESC>:w<CR>:!stylus -c --include-css `find "%:p:h" -name "*.styl" \! -name "-*"`<CR>a
" autocmd BufEnter *.styl nmap <C-s> :w<CR>:!stylus -c --include-css `find "%:p:h" -name "*.styl" \! -name "-*" \! -name "_*"`; find . -name '*.css' \! -name '-*' \! -name '_*' -exec csso -i {} -o {} \;<CR>
autocmd BufEnter *.styl nmap <C-s> :w<CR>:!stylus -c --include-css "%"<CR>
"`find "%:p:h" -name "*.styl" \! -name "-*" \! -name "_*"`; find . -name '*.css' \! -name '-*' \! -name '_*' -exec csso -i {} -o {} \;<CR>
autocmd BufEnter *.styl setlocal foldmethod=marker foldmarker=\/\/\:,endfold

":1 Other
autocmd BufEnter Rakefile nmap <F5> :w<CR>:!rake<CR>
autocmd BufEnter Makefile nmap <F5> :w<CR>:!make<CR>

autocmd FileType help nnoremap <buffer> <CR> <C-]>
autocmd FileType help nnoremap <buffer> <BS> <C-T>

":1 Filetype detection
autocmd BufEnter *.gitignore setlocal filetype=gitconfig

":1 Tab configuration for filetypes
" use tab. tabsize = 4
autocmd FileType php
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" use tab. tabsize = 2
autocmd FileType cpp,c,java,snippets
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab

" no tab use. tab = 4 space
autocmd FileType python,sh
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" no tab use. tab = 2 space
autocmd FileType cucumber,css,vim,javascript,stylus,yaml,markdown,ruby,coffee,html
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" endfold
