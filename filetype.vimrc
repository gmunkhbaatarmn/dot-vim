":1 Python
function! PythonFold()
  let line = getline(v:lnum)
  let prevline = getline(v:lnum-1)
  let nextline = getline(v:lnum+1)

  if line =~ '^from ' || line =~ '^import '
    if prevline !~ '^from ' && prevline !~ '^import ' && getline(v:lnum-2) !~ '^from ' && getline(v:lnum-2) !~ '^import '
      return ">1"
    endif
  endif

  if prevline =~ '^from ' || prevline =~ '^import '
    if nextline == "" && line == ""
      return "0"
    endif
  endif

  " Level 0
  if line =~ '^$' && nextline =~ '^$'
    return "0"
  endif

  " Level 1
  if line =~ '^class ' || line =~ '^def '
    return ">1"
  endif

  " Level 2
  if line =~ '^    class ' || line =~ '^    def '
    return ">2"
  endif

  " Level 3
  if line =~ '^        class ' || line =~ '^        def '
    return ">3"
  endif

  if line =~ "endfold"
    return "0"
  endif

  return "="
endfunction

autocmd FileType python setlocal foldmethod=expr foldexpr=PythonFold()

autocmd BufEnter * if &filetype == 'python' |nmap <F5>   :w<CR>:!time python '%'            <CR>| endif
autocmd BufEnter * if &filetype == 'python' |nmap <S-F5> :w<CR>:!time python '%' < input.txt<CR>| endif
autocmd BufEnter * if &filetype == 'python' |nmap <F9>   :w<CR>:!pep8 '%'                   <CR>| endif

" Highlight `CAPITALIZED:`
autocmd FileType python syn match DocKeyword "\s*[A-Z]\+\(\s\|\n\)"he=e-1 containedin=pythonString contained
" Highlight `{Regular-word}`
autocmd FileType python syn match DocKeyword "{[a-zA-Z0-9_-]\+}"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `%(word)s`
autocmd FileType python syn match DocKeyword "%([a-zA-Z0-9_]\+)s"hs=s+1,he=e-1 containedin=pythonString contained
" Highlight `%s`
autocmd FileType python syn match DocKeyword "%s"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `:Regular-word`
autocmd FileType python syn match DocKeyword "\:[a-zA-Z0-9_-]\+"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `>>`
autocmd FileType python syn match DocKeyword ">>" containedin=pythonString contained

" Highlight `argument - `
autocmd FileType python syn match DocArgument "\s*[A-Za-z0-9_\-&\*:]*\(\s*- \)"he=e-2 containedin=pythonString contained
" Highlight `=>`
autocmd FileType python syn match DocArgument "=>" containedin=pythonString contained

autocmd FileType python hi default link DocArgument HELP
autocmd FileType python hi default link DocKeyword Comment

":1 coffee    Coffeescript
autocmd FileType coffee setlocal foldmethod=marker foldmarker=#\:,endfold

autocmd BufEnter * if &filetype == "coffee" |nmap <F9>       :w<CR>:       !coffee "%" --nodejs               <CR>| endif
autocmd BufEnter * if &filetype == "coffee" |nmap <F5>       :w<CR>:       !coffee -c -b -p "%" > "%:r.min.js"<CR>| endif
autocmd BufEnter * if &filetype == "coffee" |nmap <C-s>      :w<CR>:silent !coffee -c -b -p "%" > "%:r.min.js"<CR>| endif
autocmd BufEnter * if &filetype == "coffee" |imap <C-s> <ESC>:w<CR>:silent !coffee -c -b -p "%" > "%:r.min.js"<CR>| endif

":1 Javascript
autocmd FileType javascript setlocal foldmethod=marker foldmarker={,} autoindent

autocmd BufEnter * if &filetype == 'javascript' |nmap <F5> :w<CR>:!time node "%" <CR>| endif

":1 ruby      Ruby
autocmd BufEnter * if &filetype == 'ruby' |nmap <F5>   :w<CR>:!time ruby "%"            <CR>| endif
autocmd BufEnter * if &filetype == 'ruby' |nmap <S-F5> :w<CR>:!time ruby "%" < input.txt<CR>| endif

":1 java      Java source file
autocmd FileType java setlocal foldmethod=marker foldmarker=BEGIN\ CUT\ HERE,END\ CUT\ HERE

autocmd BufEnter * if &filetype == 'java' |nmap <F5>   :w<CR>:!javac "%"; java "%:t:r";             rm -f "%:r.class" "%:rHarness.class"<CR>| endif
autocmd BufEnter * if &filetype == 'java' |nmap <S-F5> :w<CR>:!javac "%"; java "%:t:r" < input.txt; rm -f "%:r.class" "%:rHarness.class"<CR>| endif
" endif

":1 vim       Vimscript file
autocmd FileType vim setlocal foldmethod=marker foldmarker=\"\:,\"\ endfold

":1 C         C source file
autocmd BufEnter * if &filetype == 'c' |nmap <F9>   :w<CR>:!gcc "%" -Wall -lm -o "%:p:h/a"<CR>| endif
autocmd BufEnter * if &filetype == 'c' |nmap <F5>   :w<CR>:!time "%:p:h/a"                <CR>| endif
autocmd BufEnter * if &filetype == 'c' |nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt    <CR>| endif

":1 C++       C++ source file
autocmd FileType cpp setlocal foldmethod=marker foldmarker=\/\/\ created\:,\/\/\ end

autocmd BufEnter * if &filetype == 'cpp' |nmap <F9>   :w<CR>:!g++ "%" -Wall -o "%:p:h/a" -O3<CR>| endif
autocmd BufEnter * if &filetype == 'cpp' |nmap <F5>   :w<CR>:!time "%:p:h/a"                <CR>| endif
autocmd BufEnter * if &filetype == 'cpp' |nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt    <CR>| endif

autocmd FileType cpp syn keyword cType string
autocmd FileType cpp syn keyword cType Vector
autocmd FileType cpp syn keyword cType Pair
autocmd FileType cpp syn keyword cType Set
autocmd FileType cpp syn keyword cType Long
autocmd FileType cpp syn keyword cType stringstream
autocmd FileType cpp syn keyword cRepeat For Rep
autocmd FileType cpp syn match cComment /;/

":1 PHP       PHP source file
autocmd BufEnter * if &filetype == 'php' |nmap <F5> :w<CR>:!time php "%"<CR>|endif

":1 Markdown
autocmd BufEnter Notes     nmap <F9> :w<CR>:!/Users/mb/.reminders &<CR><CR>:echo "Reminder syncing"<CR>
autocmd BufEnter Todos     nmap <F9> :w<CR>:!/Users/mb/.todos      <CR><CR>:echo "Todos updated"<CR>
autocmd BufEnter Greatness nmap <F9> :w<CR>:!/Users/mb/.greatness  <CR><CR>:echo "Book updated"<CR>

autocmd BufEnter Notes     setlocal filetype=markdown
autocmd BufEnter Todos     setlocal filetype=markdown
autocmd BufEnter Greatness setlocal filetype=markdown
autocmd BufEnter Issues    setlocal filetype=markdown

autocmd FileType markdown syn match CheckdownLabel '[^\[\]\(\)\ ]\+:\s' containedin=TodoLine
autocmd FileType markdown hi def link CheckdownLabel Float

" Inline math. Example: Pythagorean $a^2 + b^2 = c^2$
autocmd FileType markdown syn region markdownCode start=/\s*$[^$]*/ end=/[^$]*$\s*/

" Display math. Example: Quadratic Equations $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$
autocmd FileType markdown syn region markdownCode start=/\s*$$[^$]*/ end=/[^$]*$$\s*/

autocmd FileType markdown hi def link markdownCode Comment
autocmd FileType markdown hi def link markdownCode String

" Underline fix
autocmd FileType markdown syn match Text "\w\@<=_\w\@="

" Markdown syntax bug fix
autocmd FileType markdown syn region htmlBold start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contains=markdownLineStart
autocmd FileType markdown syn region markdownBoldItalic start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contains=markdownLineStart
autocmd FileType markdown syn region markdownBoldItalic start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contains=markdownLineStart

":1 HTML, HTML-jinja
autocmd FileType html setlocal filetype=htmljinja
autocmd FileType htmljinja setlocal foldmethod=marker foldmarker=#\:,endfold

" Inline math. Example: Pythagorean $a^2 + b^2 = c^2$
autocmd FileType htmljinja syn region mathjax start=/\s*$[^$]*/ end=/[^$]*$\s*/

" Display math. Example: Quadratic Equations $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$
autocmd FileType htmljinja syn region mathjax start=/\s*$$[^$]*/ end=/[^$]*$$\s*/

autocmd FileType htmljinja hi def link mathjax Comment

":1 Shell script
autocmd BufEnter * if &filetype == 'sh' |nmap <F5> :w<CR>:!sh "%"<CR>| endif

":1 Stylus
autocmd FileType stylus setlocal foldmethod=marker foldmarker=\/\/\:,endfold
autocmd FileType stylus setlocal iskeyword-=#,-

autocmd BufEnter * if &filetype == 'stylus' |nmap <C-s>      :w<CR>:!stylus -u nib --include-css -p "%" > "%:r.min.css"<CR>| endif
autocmd BufEnter * if &filetype == 'stylus' |imap <C-s> <ESC>:w<CR>:!stylus -u nib --include-css -p "%" > "%:r.min.css"<CR>| endif
autocmd BufEnter * if &filetype == 'stylus' |nmap <F5>       :w<CR>:!stylus -u nib --include-css -p "%" > "%:r.min.css"<CR>| endif

":1 Other
autocmd BufEnter Rakefile nmap <F5> :w<CR>:!rake<CR>
autocmd BufEnter Makefile nmap <F5> :w<CR>:!make<CR>

autocmd FileType help nnoremap <buffer> <CR> <C-]>
autocmd FileType help nnoremap <buffer> <BS> <C-T>

":1 Filetype detection
autocmd BufEnter *.gitignore setlocal filetype=gitconfig
autocmd BufEnter *.conf setlocal filetype=dosini

":1 Tab configuration for filetypes
" use tab. tabsize = 4
autocmd FileType php
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" use tab. tabsize = 2
autocmd FileType cpp,c,java,snippets,make
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab

" no tab use. tab = 4 space
autocmd FileType python,sh
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" no tab use. tab = 2 space
autocmd FileType cucumber,css,vim,javascript,stylus,yaml,markdown,ruby,coffee,html,xhtml,htmljinja
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" endfold
