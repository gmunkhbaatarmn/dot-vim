":1 Python
let $PYTHONDONTWRITEBYTECODE=1
let $PYTHONIOENCODING='utf-8'
let $PYTHONPATH='/usr/local/google_appengine:/usr/local/lib/python2.7/site-packages'

" todo: python fold function. has lot of bug. fix them all.
function! PythonFold()
  ":2
  if v:lnum == 1
    let s:python_fold_state = "normal"  " (docstring, normal)
    let s:python_fold_level = 0
  endif

  let line = getline(v:lnum)
  let prevline = getline(v:lnum-1)
  let nextline = getline(v:lnum+1)
  let prevline2 = getline(v:lnum-2)
  let nextline2 = getline(v:lnum+2)
  let prevline3 = getline(v:lnum-3)
  let nextline3 = getline(v:lnum+3)
  " endfold

  " if line == "" && prevline == ""
  "   return "="
  " endif

  if line == "" && nextline == ""
    return "="
  endif

  ":2 if python_fold_state == "docstring"
  if s:python_fold_state == "docstring"
    if prevline =~ '^"""$'
      let s:python_fold_state = "normal"
      return '0'  " closing
    endif

    if prevline =~ '^[ ]\{4}"""$'
      let s:python_fold_state = "normal"
      return '1'  " closing
    endif

    if prevline =~ '^[ ]\{8}"""$'
      let s:python_fold_state = "normal"
      return '2'  " closing
    endif

    return '='
  endif
  " endfold

  ":2 normal
  " imports - first line
  if prevline2 !~ '^\(from\|import\) '
    if prevline !~ '^\(from\|import\) '
      if line =~ '^\(from\|import\) '
        return '>1'  " entering
      endif
    endif
  endif

  " level:1 - docstring
  if line =~ '^""".'
    let s:python_fold_state = "docstring"
    return '>1'  " entering
  endif

  " level:1 - begin
  if prevline !~ '^@'
    if line =~ '^\(class \|def \|if \|@\)'
      return '>1'  " entering
    endif
  endif

  " imports - last line
  if prevline2 =~ '^\(from\|import\) '
    if prevline !~ '^\(from\|import\) '
      if line !~ '^\(from\|import\) '
        return '0'  " closing
      endif
    endif
  endif

  " level:1 - comment separator
  if line == ''
    if nextline =~ '^\S' && nextline !~ '^\(class \|def \|@\)'
      return '0'  " closing
    endif
  endif

  if line =~ '^[ ]\{4}""".'
    let s:python_fold_state = "docstring"
    return '>2'  " entering
  endif

  ":2 level:2 - begin with decorator
  if prevline !~ '^[ ]\{4}\(class \|def \|@\)'
    if line =~ '^[ ]\{4}\(class \|def \|@\|# - \)'
      return '>2'  " entering
    endif
  endif

  if line == '' && nextline == ''
    return '1'  " closing
  endif

  " level:2 - end
  if line == ''
    if nextline =~ '^[ ]\{4}\S' && nextline !~ '^[ ]\{4}\(class \|def \|@\)'
      return '1'  " closing
    endif
  endif
  " endfold

  ":2 level:3 - docstring
  if line =~ '^[ ]\{8}""".'
    let s:python_fold_state = "docstring"
    return '>3'  " entering
  endif
  " endfold

  return '='
endfunction

function! PythonFoldText()
  let line = getline(v:foldstart)
  let trimmed = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let leading_spaces = stridx(line, trimmed)
  let prefix = repeat(" ", leading_spaces)
  let foldedlinecount = v:foldend - v:foldstart
  let nextline = getline(v:foldstart + 1)
  let nextline_trimmed = substitute(nextline, '^\s*\(.\{-}\)\s*$', '\1', '')

  if trimmed =~ '"""'
    let custom_text = '✎ …' . strpart(trimmed, 3)

  elseif trimmed =~ '@classmethod'
    let custom_text = substitute(nextline_trimmed, ':', '', '') . ' (classmethod)'

  elseif trimmed =~ '@property'
    let custom_text = 'def @' . strpart(substitute(nextline_trimmed, ':', '', ''), 4)

  elseif trimmed =~ '@'
    let fillcharcount = 80 - len(prefix) - len(trimmed)
    let custom_text = trimmed . repeat(' ', fillcharcount) . substitute(nextline_trimmed, ':', '', '')

  elseif trimmed =~ 'def '
    let custom_text = 'def ' . substitute(strpart(trimmed, 4), ':', '', '')

  elseif trimmed =~ 'class '
    let custom_text = 'class ' . substitute(strpart(trimmed, 6), ':', '', '')
  else
    return foldtext()
  endif

  return prefix . custom_text
endfunction

autocmd FileType python setlocal foldmethod=expr foldexpr=PythonFold() foldtext=PythonFoldText()
autocmd FileType python setlocal textwidth=79

autocmd BufEnter * if &filetype == 'python' |nmap <F5>   :w<CR>:!time python '%'            <CR>| endif
autocmd BufEnter * if &filetype == 'python' |nmap <S-F5> :w<CR>:!time python '%' < input.txt<CR>| endif
autocmd BufEnter * if &filetype == 'python' |nmap <F9>   :w<CR>:!pep8 '%'                   <CR>| endif
autocmd FileType python syn match DocKeyword "Returns" containedin=pythonString contained

" Show line in 80th column
autocmd BufEnter * if &filetype == 'python' |let &colorcolumn=join(range(80,80),",") | endif
autocmd BufEnter * if &filetype != 'python' |let &colorcolumn=""                     | endif

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
" Highlight `#Regular-word`
autocmd FileType python syn match DocKeyword "\#[a-zA-Z0-9_-]\+"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `>>`
autocmd FileType python syn match DocKeyword ">>" containedin=pythonString contained

" Highlight `argument - `
autocmd FileType python syn match DocArgument "\s*[A-Za-z0-9_\-&\*:]*\(\s*- \)"he=e-2 containedin=pythonString contained
" Highlight `=>`
autocmd FileType python syn match DocArgument "=>" containedin=pythonString contained

autocmd FileType python hi default link DocArgument HELP
autocmd FileType python hi default link DocKeyword Comment

":1 Coffeescript
autocmd FileType coffee setlocal foldmethod=marker foldmarker=#\:,endfold

autocmd BufEnter * if &filetype == "coffee" |nmap <F9>       :w<CR>:       !coffee "%" --nodejs               <CR>| endif
autocmd BufEnter * if &filetype == "coffee" |nmap <F5>       :w<CR>:       !coffee -c -b -p "%" > "%:r.min.js"<CR>| endif
autocmd BufEnter * if &filetype == "coffee" |nmap <C-s>      :w<CR>:silent !coffee -c -b -p "%" > "%:r.min.js"<CR>| endif
autocmd BufEnter * if &filetype == "coffee" |imap <C-s> <ESC>:w<CR>:silent !coffee -c -b -p "%" > "%:r.min.js"<CR>| endif

":1 Javascript
autocmd FileType javascript setlocal foldmethod=marker foldmarker={,} autoindent

autocmd BufEnter * if &filetype == 'javascript' |nmap <F5> :w<CR>:!time node "%" <CR>| endif

":1 Ruby
autocmd BufEnter * if &filetype == 'ruby' |nmap <F5>   :w<CR>:!time ruby "%"            <CR>| endif
autocmd BufEnter * if &filetype == 'ruby' |nmap <S-F5> :w<CR>:!time ruby "%" < input.txt<CR>| endif

":1 Java
autocmd FileType java setlocal foldmethod=marker foldmarker=BEGIN\ CUT\ HERE,END\ CUT\ HERE

autocmd BufEnter * if &filetype == 'java' |nmap <F5>   :w<CR>:!javac "%"; java "%:t:r";             rm -f "%:r.class" "%:rHarness.class"<CR>| endif
autocmd BufEnter * if &filetype == 'java' |nmap <S-F5> :w<CR>:!javac "%"; java "%:t:r" < input.txt; rm -f "%:r.class" "%:rHarness.class"<CR>| endif

":1 Vim (Vimscript)
autocmd FileType vim setlocal foldmethod=marker foldmarker=\"\:,\"\ endfold

":1 C
autocmd BufEnter * if &filetype == 'c' |nmap <F9>   :w<CR>:!gcc "%" -Wall -lm -o "%:p:h/a"<CR>| endif
autocmd BufEnter * if &filetype == 'c' |nmap <F5>   :w<CR>:!time "%:p:h/a"                <CR>| endif
autocmd BufEnter * if &filetype == 'c' |nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt    <CR>| endif

":1 C++
function! CppFoldText()
  let line = getline(v:foldstart)
  let trimmed = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let leading_spaces = stridx(line, trimmed)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, leading_spaces * &tabstop + 12, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return repeat(onetab, leading_spaces). '▸' . printf("%3s", foldedlinecount) . ' lines ' . line . '' . repeat(" ",fillcharcount) . '(' . foldedlinecount . ')' . ' '
endfunction

autocmd FileType cpp setlocal foldmethod=marker foldmarker=\/\/\ created\:,\/\/\ end
autocmd FileType cpp setlocal foldtext=CppFoldText()

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

":1 PHP
autocmd BufEnter * if &filetype == 'php' |nmap <F5> :w<CR>:!time php "%"<CR>|endif

":1 Markdown
autocmd BufEnter Greatness nmap <F9> :w<CR>:!'/Users/mb/.greatness' <CR><CR>:echo "Book updated"<CR>
autocmd BufEnter Greatness setlocal filetype=markdown

nmap <F7> :e $HOME/Notes<CR>
autocmd BufEnter Notes     setlocal filetype=markdown

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

function! MarkdownFold()
  let line = getline(v:lnum)

  " Regular headers
  let depth = match(line, '\(^#\+\)\@<=\( .*$\)\@=')
  if depth > 0
    return ">" . depth
  endif

  " Setext style headings
  let nextline = getline(v:lnum + 1)
  if (line =~ '^.\+$') && (nextline =~ '^=\+$')
    return ">1"
  endif

  if (line =~ '^.\+$') && (nextline =~ '^-\+$')
    return ">2"
  endif

  if (getline(v:lnum - 0) =~ "endfold")
    return "0"
  endif

  return "="
endfunction
autocmd Filetype markdown setlocal foldexpr=MarkdownFold()

":1 HTML, HTML-jinja
autocmd BufNewFile,BufRead *.html setlocal filetype=htmljinja

autocmd FileType htmljinja setlocal foldmethod=marker foldmarker=#\:,endfold

" Inline math. Example: Pythagorean $a^2 + b^2 = c^2$
autocmd FileType htmljinja syn region mathjax start=/\s*$[^$]*/ end=/[^$]*$\s*/

" Display math. Example: Quadratic Equations $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$
autocmd FileType htmljinja syn region mathjax start=/\s*$$[^$]*/ end=/[^$]*$$\s*/

autocmd FileType htmljinja hi def link mathjax Comment

":1 Shell script
autocmd BufEnter * if &filetype == 'sh' |nmap <F5> :w<CR>:!sh "%"<CR>| endif

":1 Stylus
function! StylusFoldText()
  let line = getline(v:foldstart)
  let trimmed = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let leading_spaces = stridx(line, trimmed)
  let prefix = repeat(" ", leading_spaces)
  let fillcharcount = 60 - len(prefix) - len(trimmed)
  let foldedlinecount = v:foldend - v:foldstart

  if strpart(trimmed, 0, 5) == '//:1 '
    return prefix . strpart(trimmed, 4) . repeat(" ", fillcharcount) . '⋮ ' . foldedlinecount
  endif

  return foldtext()
endfunction

autocmd FileType stylus setlocal foldmethod=marker foldmarker=\/\/\:,endfold foldtext=StylusFoldText()
autocmd FileType stylus setlocal iskeyword-=#,-

autocmd BufEnter * if &filetype == 'stylus' |nmap <C-s>      :w<CR>:!stylus -u nib -u jeet -u normalize.stylus --include-css -p "%" > "%:r.styl.css"<CR>| endif
autocmd BufEnter * if &filetype == 'stylus' |imap <C-s> <ESC>:w<CR>:!stylus -u nib -u jeet -u normalize.stylus --include-css -p "%" > "%:r.styl.css"<CR>| endif
autocmd BufEnter * if &filetype == 'stylus' |nmap <F5>       :w<CR>:!stylus -u nib -u jeet -u normalize.stylus --include-css -p "%" > "%:r.styl.css"<CR>| endif

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
