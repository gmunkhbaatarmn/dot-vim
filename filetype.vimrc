scriptencoding utf-8

":1 Python
let $PYTHONDONTWRITEBYTECODE = 1
let $PYTHONIOENCODING = 'utf-8'

":2 PythonFoldExpr
function! PythonFoldExpr()
  if v:lnum == 1
    let s:in_docstring = 0
    let s:current_indent = 0
    let s:manual_fold = 0
  endif

  " if docstring started
  if s:in_docstring
    ":3 Case: docstring close
    if getline(v:lnum) =~? '"""'
      let s:in_docstring = 0
      let return_indent = s:current_indent
      let s:current_indent -= 1

      return '<' . return_indent
    endif

    ":3 Case: still in docstring
    return '='

    " endfold
  " if not in docstring
  else
    ":3 Case: docstring start
    if getline(v:lnum) =~? '"""' && getline(v:lnum) !~? '""".*"""$'
      let s:in_docstring = 1
      let s:current_indent += 1

      return '>' . s:current_indent
    endif

    ":3 Case: 2 emply line trailing line
    if getline(v:lnum - 1) !~? '\v\S' && getline(v:lnum) !~? '\v\S' && getline(v:lnum + 1) !~? '^\(class \|def \|@\)'
      return '0'
    endif

    ":3 Case: 2 empty line allowed in zero indent
    if s:current_indent > 0 && getline(v:lnum) =~? '\v\S' && getline(v:lnum) !~? '\v\S' && getline(v:lnum + 1) !~? '\v\S'
      return '1'
    endif

    ":3 Case: next 2 line is empty
    if s:current_indent > 0 && getline(v:lnum + 1) !~? '\v\S' && getline(v:lnum + 2) !~? '\v\S'
      let s:current_indent = 1

      return '<2'
    endif

    ":3 Case: close current indent. (exclude not empty line)
    if getline(v:lnum + 1) =~? '\v\S' && indent(v:lnum + 1) / &shiftwidth + s:manual_fold < s:current_indent
      let return_indent = s:current_indent
      let s:current_indent -= 1
      let s:manual_fold = 0

      return '<' . return_indent
    endif

    ":3 Case: if previous line is decorator
    if getline(v:lnum - 1) =~? '^[ ]*@'
      return '='
    endif

    ":3 Case: start with '# - '
    if getline(v:lnum) =~? '^[ ]*# -'
      let s:current_indent = (indent(v:lnum) / &shiftwidth) + 1
      let s:manual_fold = 1
      return '>' . s:current_indent
    endif

    ":3 Case: start with '# endfold'
    if s:manual_fold > 0 && getline(v:lnum) =~? '^[ ]*# endfold'
      let return_indent = s:current_indent
      let s:current_indent -= 1
      let s:manual_fold = 0
      return '<' . return_indent
    endif

    ":3 Case: start with '@', 'class', 'def'
    if getline(v:lnum) =~? '^[ ]*\(class \|def \|@\)'
      let s:current_indent = (indent(v:lnum) / &shiftwidth) + 1

      return '>' . s:current_indent
    endif

    ":3 Case: 'if' 'for' only start a line
    if getline(v:lnum) =~? '^\(if \|for \)'
      return '>1'
    endif

    ":3 Case: import lines indent open
    if getline(v:lnum) =~? '^\(from\|import\) '
      return '1'
    endif

    ":3 Case: import lines indent close
    if getline(v:lnum - 2) =~? '^\(from\|import\) ' && getline(v:lnum-1) !~? '^\(from\|import\) '
      return '0'
    endif
    " endfold
    return '='
  endif
endfunction

":2 PythonFoldText
function! PythonFoldText()
  let line = getline(v:foldstart)
  let trimmed = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let leading_spaces = stridx(line, trimmed)
  let prefix = repeat(' ', leading_spaces)
  let foldedlinecount = v:foldend - v:foldstart
  let nextline = getline(v:foldstart + 1)
  let nextline_trimmed = substitute(nextline, '^\s*\(.\{-}\)\s*$', '\1', '')

  if trimmed =~# '"""'
    let custom_text = '✎ …' . strpart(trimmed, 3)

  elseif trimmed =~# '^@classmethod'
    let custom_text = substitute(nextline_trimmed, ':', '', '') . ' (classmethod)'

  elseif trimmed =~# '^@property'
    let custom_text = 'def @' . strpart(substitute(nextline_trimmed, ':', '', ''), 4)

  elseif trimmed =~# '@'
    let fillcharcount = 80 - len(prefix) - len(substitute(trimmed, '.', '-', 'g'))
    let custom_text = trimmed . repeat(' ', fillcharcount) . substitute(nextline_trimmed, ':', '', '')

  elseif trimmed =~# '^# - '
    let custom_text = printf('▸%2s ', v:foldend - v:foldstart) . strpart(trimmed, 4)

  elseif trimmed =~# '^if '
    let custom_text = 'if ' . substitute(strpart(trimmed, 3), ':', '', '')

  elseif trimmed =~# '^for '
    let custom_text = 'for ' . substitute(strpart(trimmed, 4), ':', '', '')

  elseif trimmed =~# '^def '
    let custom_text = 'def ' . substitute(strpart(trimmed, 4), ':', '', '')

  elseif trimmed =~# '^class '
    let custom_text = 'class ' . substitute(strpart(trimmed, 6), ':', '', '')
  else
    return foldtext()
  endif

  return prefix . custom_text
endfunction
" endfold

autocmd vimrc FileType python setlocal foldmethod=expr foldexpr=PythonFoldExpr() foldtext=PythonFoldText()
autocmd vimrc FileType python setlocal textwidth=79
autocmd vimrc BufWritePost,InsertLeave *.py setlocal filetype=python

autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F5>   :w<CR>:!time python '%'            <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'python' |nmap <S-F5> :w<CR>:!time python '%' < input.txt<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F9>   :w<CR>:!pep8 '%'                   <CR>| endif

" Show line in 80th column
autocmd vimrc BufEnter * if &filetype == 'python' |let &colorcolumn=join(range(80,80),",") | endif
autocmd vimrc BufEnter * if &filetype != 'python' |let &colorcolumn=""                     | endif

":2 Python custom hightlights
autocmd vimrc FileType python syn match DocKeyword "Returns" containedin=pythonString contained
" Highlight `CAPITALIZED:`
autocmd vimrc FileType python syn match DocKeyword "\s*[A-Z]\+\(\s\|\n\)"he=e-1 containedin=pythonString contained
" Highlight `{Regular-word}`
autocmd vimrc FileType python syn match DocKeyword "{[a-zA-Z0-9_-]\+}"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `%(word)`
autocmd vimrc FileType python syn match DocKeyword "%([a-zA-Z0-9_]\+)"hs=s+1,he=e-0 containedin=pythonString contained
" Highlight `%s`
autocmd vimrc FileType python syn match DocKeyword "%s"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `:Regular-word`
autocmd vimrc FileType python syn match DocKeyword "\:[a-zA-Z0-9_-]\+"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `#Regular-word`
autocmd vimrc FileType python syn match DocKeyword "\#[a-zA-Z0-9_-]\+"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `>>`
autocmd vimrc FileType python syn match DocKeyword ">>" containedin=pythonString contained
" Highlight `self.`
autocmd vimrc FileType python syn match Keyword "self\."

" Highlight `argument - `
autocmd vimrc FileType python syn match DocArgument "\s*[A-Za-z0-9_\-&\*:]*\(\s*- \)"he=e-2 containedin=pythonString contained
" Highlight `=>`
autocmd vimrc FileType python syn match DocArgument "=>" containedin=pythonString contained

autocmd vimrc FileType python hi default link DocArgument HELP
autocmd vimrc FileType python hi default link DocKeyword Comment
" endfold

":1 Coffeescript
autocmd vimrc FileType coffee setlocal foldmethod=marker foldmarker=#\:,endfold

autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |nmap <F9>       :w<CR>:!coffee "%" --nodejs        <CR>| endif
autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |nmap <F5>       :w<CR>:!coffee -c -b -p "%" > "%:r"<CR>| endif
autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |nmap <C-s>      :w<CR>:!coffee -c -b -p "%" > "%:r"<CR>| endif
autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |imap <C-s> <ESC>:w<CR>:!coffee -c -b -p "%" > "%:r"<CR>| endif

":1 Javascript
autocmd vimrc FileType javascript setlocal foldmethod=marker foldmarker=\/\/\:,\/\/\ endfold autoindent

autocmd vimrc BufEnter * if &filetype == 'javascript' |nmap <F5> :w<CR>:!time node "%" <CR>| endif

":1 Ruby
autocmd vimrc BufEnter * if &filetype == 'ruby' |nmap <F5>   :w<CR>:!time ruby "%"            <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'ruby' |nmap <S-F5> :w<CR>:!time ruby "%" < input.txt<CR>| endif

":1 Java
autocmd vimrc FileType java setlocal foldmethod=marker foldmarker=BEGIN\ CUT\ HERE,END\ CUT\ HERE

autocmd vimrc BufEnter * if &filetype == 'java' |nmap <F5>   :w<CR>:!javac "%"; java "%:t:r";             rm -f "%:r.class" "%:rHarness.class"<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'java' |nmap <S-F5> :w<CR>:!javac "%"; java "%:t:r" < input.txt; rm -f "%:r.class" "%:rHarness.class"<CR>| endif

":1 Vim (Vimscript)
autocmd vimrc FileType vim setlocal foldmethod=marker foldmarker=\"\:,\"\ endfold

":1 Yaml
function! YamlFoldText()
  let line = getline(v:foldstart)
  let trimmed = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let leading_spaces = stridx(line, trimmed)
  let prefix = repeat(' ', leading_spaces)
  let size = strlen(trimmed)

  let trimmed = strpart(trimmed, 4, size - 4)
  return prefix . '▸   ' . trimmed
endfunction
autocmd vimrc FileType yaml setlocal foldmethod=marker foldmarker=#:,#\ endfold foldtext=YamlFoldText()
autocmd vimrc FileType yaml highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd vimrc FileType yaml match OverLength /\%120v.\+/

":1 Makefile
function! MakefileFoldExpr()
  " Case: start with 'COMMAND:'
  if getline(v:lnum) =~? '^[a-z-]\+:$'
    return '>1'
  endif

  return '='
endfunction

autocmd vimrc FileType make setlocal foldmethod=expr foldexpr=MakefileFoldExpr() foldtext=strpart(getline(v:foldstart),0,strlen(getline(v:foldstart))-1)

":1 C
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <F9>   :w<CR>:!gcc "%" -Wall -lm -o "%:p:h/a"<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <F5>   :w<CR>:!time "%:p:h/a"                <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt    <CR>| endif

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
  return repeat(onetab, leading_spaces). '▸' . printf('%3s', foldedlinecount) . ' lines ' . line . '' . repeat(' ', fillcharcount) . '(' . foldedlinecount . ')' . ' '
endfunction

autocmd vimrc FileType cpp setlocal foldmethod=marker foldmarker=\/\/\ created\:,\/\/\ end
autocmd vimrc FileType cpp setlocal foldtext=CppFoldText()

autocmd vimrc BufEnter * if &filetype == 'cpp' |nmap <F9>   :w<CR>:!g++ "%" -Wall -o "%:p:h/a" -O3<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'cpp' |nmap <F5>   :w<CR>:!time "%:p:h/a"                <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'cpp' |nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt    <CR>| endif

autocmd vimrc FileType cpp syn keyword cType string
autocmd vimrc FileType cpp syn keyword cType Vector
autocmd vimrc FileType cpp syn keyword cType Pair
autocmd vimrc FileType cpp syn keyword cType Set
autocmd vimrc FileType cpp syn keyword cType Long
autocmd vimrc FileType cpp syn keyword cType stringstream
autocmd vimrc FileType cpp syn keyword cRepeat For Rep
autocmd vimrc FileType cpp syn match cComment /;/

":1 PHP
autocmd vimrc BufEnter * if &filetype == 'php' |nmap <F5> :w<CR>:!time php "%"<CR>|endif

":1 Markdown
autocmd vimrc BufEnter Greatness nmap <F9> :w<CR>:!'/Users/mb/.greatness' <CR><CR>:echo "Book updated"<CR>
autocmd vimrc BufEnter Greatness setlocal filetype=markdown

nmap <F7> :e $HOME/Notes<CR>
autocmd vimrc BufEnter Notes     setlocal filetype=markdown

autocmd vimrc FileType markdown syn match CheckdownLabel '[^\[\]\(\)\ ]\+:\s' containedin=TodoLine
autocmd vimrc FileType markdown hi def link CheckdownLabel Float

" Inline math. Example: Pythagorean $a^2 + b^2 = c^2$
autocmd vimrc FileType markdown syn region markdownCode start=/\s*$[^$]*/ end=/[^$]*$\s*/

" Display math. Example: Quadratic Equations $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$
autocmd vimrc FileType markdown syn region markdownCode start=/\s*$$[^$]*/ end=/[^$]*$$\s*/

autocmd vimrc FileType markdown hi def link markdownCode Comment
autocmd vimrc FileType markdown hi def link markdownCode String

" Underline fix
autocmd vimrc FileType markdown syn match Text "\w\@<=_\w\@="

" Markdown syntax bug fix
autocmd vimrc FileType markdown syn region htmlBold start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contains=markdownLineStart
autocmd vimrc FileType markdown syn region markdownBoldItalic start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contains=markdownLineStart
autocmd vimrc FileType markdown syn region markdownBoldItalic start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contains=markdownLineStart

":1 HTML, HTML-jinja
function! HTMLFoldText()
  let line = getline(v:foldstart)
  let trimmed = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let leading_spaces = stridx(line, trimmed)
  let prefix = repeat(' ', leading_spaces)
  let size = strlen(trimmed)

  if trimmed[0] == '{'
    let trimmed = strpart(trimmed, 5, size - 5)
    let trimmed = substitute(trimmed, '{', '', 'g')
    let trimmed = substitute(trimmed, '#', '', 'g')
    let trimmed = substitute(trimmed, '}', '', 'g')
    return prefix . trimmed
  else
    let trimmed = strpart(trimmed, 4, size - 4)
    let trimmed = substitute(trimmed, '{', '', 'g')
    let trimmed = substitute(trimmed, '#', '', 'g')
    let trimmed = substitute(trimmed, '}', '', 'g')
    return prefix . '▸   ' . trimmed
  endif

endfunction

autocmd vimrc BufNewFile,BufRead *.html setlocal filetype=htmljinja
autocmd vimrc FileType htmljinja setlocal foldmethod=marker foldmarker=#\:,endfold foldtext=HTMLFoldText()

" Inline math. Example: Pythagorean $a^2 + b^2 = c^2$
autocmd vimrc FileType htmljinja syn region mathjax start=/\s*$[^$]*/ end=/[^$]*$\s*/

" Display math. Example: Quadratic Equations $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$
autocmd vimrc FileType htmljinja syn region mathjax start=/\s*$$[^$]*/ end=/[^$]*$$\s*/

autocmd vimrc FileType htmljinja hi def link mathjax Comment

":1 Shell script
autocmd vimrc BufEnter * if &filetype == 'sh' |nmap <F5> :w<CR>:!bash "%"<CR>| endif

":1 CSS
autocmd vimrc FileType css setlocal foldmethod=marker foldmarker=\/*:,\/*\ endfold\ *\/

":1 Stylus
function! StylusFoldText()
  let suffix = substitute(getline(v:foldstart), '^\s*\(.\{-}\)\s*$', '\1', '')
  let prefix = repeat(' ', stridx(getline(v:foldstart), suffix))

  if strpart(suffix, 0, 5) ==# '//:1 '
    return prefix . printf('|%2s| ', v:foldend - v:foldstart) . strpart(suffix, 5)
  endif

  return foldtext()
endfunction

autocmd vimrc FileType stylus setlocal foldmethod=marker foldmarker=\/\/\:,endfold foldtext=StylusFoldText()
autocmd vimrc FileType stylus setlocal iskeyword-=#,-

autocmd vimrc BufEnter *.css.styl if &filetype == 'stylus' |nmap <C-s>      :w<CR>:!stylus -u nib -u jeet -u stylus-normalize --include-css -p "%" > "%:r"<CR>| endif
autocmd vimrc BufEnter *.css.styl if &filetype == 'stylus' |imap <C-s> <ESC>:w<CR>:!stylus -u nib -u jeet -u stylus-normalize --include-css -p "%" > "%:r"<CR>| endif
autocmd vimrc BufEnter *.css.styl if &filetype == 'stylus' |nmap <F5>       :w<CR>:!stylus -u nib -u jeet -u stylus-normalize --include-css -p "%" > "%:r"<CR>| endif

":1 Snippets
autocmd vimrc FileType snippets setlocal foldmethod=expr foldtext=getline(v:foldstart) foldexpr=((getline(v:lnum)=~?'snippet\ ')?'>1':'1')

":1 Other
autocmd vimrc BufEnter Rakefile nmap <F5> :w<CR>:!rake<CR>
autocmd vimrc BufEnter Makefile nmap <F5> :w<CR>:!make<CR>

autocmd vimrc FileType help nnoremap <buffer> <CR> <C-]>
autocmd vimrc FileType help nnoremap <buffer> <BS> <C-T>

":1 Filetype detection
autocmd vimrc BufEnter *.gitignore setlocal filetype=gitconfig
autocmd vimrc BufEnter *.conf setlocal filetype=dosini

":1 Tab configuration for filetypes
" use tab. tabsize = 4
autocmd vimrc FileType php
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" use tab. tabsize = 2
autocmd vimrc FileType cpp,c,java,snippets,make
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab

" no tab use. tab = 4 space
autocmd vimrc FileType python,sh
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" no tab use. tab = 2 space
autocmd vimrc FileType cucumber,css,vim,javascript,stylus,yaml,markdown,ruby,coffee,htmljinja,treetop
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" endfold
