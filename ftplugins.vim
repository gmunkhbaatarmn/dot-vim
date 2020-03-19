scriptencoding utf-8

":1 Python
let $PYTHONDONTWRITEBYTECODE = 1
let $PYTHONIOENCODING = 'utf-8'

":2 PythonFoldExpr
function! g:PythonFoldExpr()
  ":3 Variable reset
  if v:lnum == 1
    let s:fold = 0          " fold level
    let s:in_docstring = 0  " in docstring
    let s:in_import = 0
  endif
  " endfold

  " if docstring started
  if s:in_docstring
    ":3 in dostring
    " Docstring close
    if getline(v:lnum) =~? '.*"""$'
      let s:in_docstring = 0
    endif

    return '='
    " endfold
  else
    ":3 == | docstring start
    if getline(v:lnum) =~? '"""'
    if getline(v:lnum) !~? '""".*"""$'
      let s:in_docstring = 1
      return '='
    endif
    endif
    " endfold

    ":3 +1 | import lines start
    if getline(v:lnum - 1) !~? '^\(from\|import\) '
    if getline(v:lnum + 0) =~? '^\(from\|import\) '
      let s:in_import = 1
      return '>1'
    endif
    endif

    ":3 =1 | import lines middle
    " if getline(v:lnum - 1) =~? '^\(from\|import\) '
    " if getline(v:lnum + 0) =~? '^\(from\|import\) '
    "   return '='
    " endif
    " endif

    ":3 -1 | import lines close
    " if getline(v:lnum - 1) =~? '^\(from\|import\) '
    " if getline(v:lnum - 0) !~? '^\(from\|import\) '
    "   return '<1'
    " endif
    " endif

    if s:in_import
      if getline(v:lnum + 0) !~? '\v\S'
        let s:in_import = 0
        return '<1'
      endif
    endif
    " endfold

    if s:in_import
      return '='
    endif

    ":3 +1 | decorator start
    if getline(v:lnum) =~? '^@click.'
      return '='
    endif

    if getline(v:lnum) =~? '^@'
      let s:fold = 1
      return '>1'
    endif

    ":3 =1 | decorator's next line
    if getline(v:lnum - 1) =~? '^@' && getline(v:lnum - 1) !~? '^@click.'
      return '='
    endif

    ":3 +1 | class|def|if|for|while start
    if getline(v:lnum) =~? '^\(class\|def\|if\|for\|while\) '
      let s:fold = 1
      return '>1'
    endif

    ":3 +1 | try|except|finally start
    if getline(v:lnum) =~? '^\(try:\|except:\|except \|finally:\)'
      let s:fold = 1
      return '>1'
    endif

    ":3 +1 | # title
    if getline(v:lnum) =~# '^# [A-Z0-9-]'
      let s:fold = 1
      return '>1'
    endif

    if s:fold == 0 && getline(v:lnum) =~# '^\s\{4\}# [A-Z0-9-]'
      let s:fold = 1
      return '>1'
    endif

    ":3 -1 | # endfold
    if getline(v:lnum) =~# '^# endfold'
      let s:fold = 0
      return '<1'
    endif

    ":3 -1 | this, next is empty, next-next is not `class |def |@`
    if getline(v:lnum + 0) !~? '\v\S'
    if getline(v:lnum + 1) !~? '\v\S'
    if getline(v:lnum + 2) !~? '^\(class \|def \|@\)'
      let s:fold = 0
      return '<1'
    endif
    endif
    endif

    ":3 =1 | 2 empty line allowed in zero indent
    if getline(v:lnum - 1) =~? '^\S'
    if getline(v:lnum + 0) !~? '\v\S'
    if getline(v:lnum + 1) !~? '\v\S'
      return '<1'
    endif
    endif
    endif
    " endfold

    ":3 +2 | decorator start
    if getline(v:lnum) =~? '^\s\{4\}@'
      let s:fold = 2
      return '>2'
    endif

    ":3 =2 | decorator's next line
    if getline(v:lnum - 1) =~? '^\s\{4\}@'
      return '='
    endif

    ":3 +2 | class|def start
    if getline(v:lnum) =~? '^\s\{4\}\(class\|def\) '
      let s:fold = 2
      return '>2'
    endif

    ":3 +2 | step("-
    if getline(v:lnum) =~? '^\s\{4\}step(\"'
      let s:fold = 2
      return '>2'
    endif

    ":3 +2 | # title
    if getline(v:lnum) =~# '^\s\{4\}# [A-Z0-9-]'
      let s:fold = 2
      return '>2'
    endif

    ":3 -2 | # endfold
    if getline(v:lnum) =~# '^\s\{4\}# endfold'
      let s:fold = 1
      return '<2'
    endif

    ":3 -2 | next, next-next is empty
    if getline(v:lnum + 1) !~? '\v\S'
    if getline(v:lnum + 2) !~? '\v\S'
      let s:fold = 1
      return '<2'
    endif
    endif
    " endfold

    ":3 +3 | class|def start
    if getline(v:lnum) =~? '^\s\{8\}\(class\|def\) '
      let s:fold = 2
      return '>3'
    endif

    ":3 +3 | # title
    if getline(v:lnum) =~# '^\s\{8,\}# [A-Z0-9-]'
      if s:fold == 1
        return '>2'
      endif
      if s:fold == 2
        return '>3'
      endif
    endif

    ":3 -3 | # endfold
    if getline(v:lnum) =~# '^\s\{8,\}# endfold'
      if s:fold == 1
        return '<2'
      endif
      if s:fold == 2
        return '<3'
      endif
    endif
    " endfold

    return '='
  endif
endfunction

":2 PythonFoldText
function! g:PythonFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:nextline = getline(v:foldstart + 1)
  let l:nextline_trimmed = substitute(l:nextline, '^\s*\(.\{-}\)\s*$', '\1', '')

  ":3 @classmethod
  if l:trimmed =~# '^@classmethod'
    let l:custom_text = '@classmethod ' . substitute(strpart(l:nextline_trimmed, 4), ':', '', '') . ''

  ":3 from|import
  elseif l:trimmed =~# '^\(from \|import \)'
    let l:custom_text = 'import'

  ":3 @task
  elseif l:trimmed =~# '^@task'
    let l:custom_text = '@task ' . strpart(l:nextline_trimmed, 4, strlen(l:nextline_trimmed) - 5)

  ":3 @cron
  elseif l:trimmed =~# '^@cron'
    let l:custom_text = '@cron ' . strpart(l:nextline_trimmed, 4, strlen(l:nextline_trimmed) - 5)

  ":3 @require("user")
  elseif l:trimmed =~# '^@require("user")'
    let l:custom_text = '@require("user") ' . strpart(l:nextline_trimmed, 4, strlen(l:nextline_trimmed) - 5)

  ":3 @require("admin")
  elseif l:trimmed =~# '^@require("admin")'
    let l:custom_text = '@require("admin") ' . strpart(l:nextline_trimmed, 4, strlen(l:nextline_trimmed) - 5)

  ":3 @property
  elseif l:trimmed =~# '^@property'
    let l:custom_text = '@property ' . strpart(split(l:nextline_trimmed, '(')[0], 4)

  ":3 .setter
  elseif l:trimmed =~# '\.setter$'
    let l:after_part = substitute(l:nextline_trimmed, ':', '', '')
    let l:custom_text = 'def @' . strpart(substitute(l:after_part, '(', '.setter(', ''), 4)

  ":3 @
  elseif l:trimmed =~# '@'
    let l:fillcharcount = 80 - len(l:prefix) - len(substitute(l:trimmed, '.', '-', 'g'))
    let l:custom_text = '@' . strpart(l:trimmed, 1) . repeat(' ', l:fillcharcount) . substitute(l:nextline_trimmed, ':', '', '')

  ":3 [CAPITAL LETTER]
  elseif l:trimmed =~# '^# [A-Z0-9-]'
    let l:custom_text = '▸ ' . strpart(l:trimmed, 2)

  ":3 def test_<name>
  elseif l:trimmed =~# '^def test_'
    let l:custom_text = l:trimmed
    let l:custom_text = 'def test ' . substitute(strpart(l:custom_text, 9), ':', ' ', '')

  ":3 def
  elseif l:trimmed =~# '^def '
    let l:custom_text = 'def ' . substitute(strpart(l:trimmed, 4), ':', ' ', '')

  ":3 class
  elseif l:trimmed =~# '^class '
    let l:custom_text = 'class ' . substitute(strpart(l:trimmed, 6), ':', '', '')

  ":3 if
  elseif l:trimmed =~# '^if '
    let l:custom_text = 'if ' . substitute(strpart(l:trimmed, 3), ':', '', '')

  ":3 for
  elseif l:trimmed =~# '^for '
    let l:custom_text = 'for ' . substitute(strpart(l:trimmed, 4), ':', '', '')

  ":3 while
  elseif l:trimmed =~# '^while '
    let l:custom_text = 'while ' . substitute(strpart(l:trimmed, 6), ':', ' ', '')

  ":3 try
  elseif l:trimmed =~# '^try:'
    let l:custom_text = 'try' . substitute(strpart(l:trimmed, 3), ':', ' ', '')

  ":3 except:
  elseif l:trimmed =~# '^except:'
    let l:custom_text = 'except' . substitute(strpart(l:trimmed, 7), ':', ' ', '')

  ":3 except
  elseif l:trimmed =~# '^except '
    let l:custom_text = 'except ' . substitute(strpart(l:trimmed, 7), ':', ' ', '')

  ":3 finally:
  elseif l:trimmed =~# '^finally:'
    let l:custom_text = 'finally' . substitute(strpart(l:trimmed, 7), ':', ' ', '')
  " endfold

  else
    return foldtext()
  endif

  return l:prefix . l:custom_text
endfunction
" endfold

autocmd vimrc FileType python setlocal foldmethod=expr foldexpr=g:PythonFoldExpr() foldtext=g:PythonFoldText()
autocmd vimrc FileType python setlocal textwidth=99
autocmd vimrc FileType python match OverLength /\%100v.\+/

autocmd vimrc BufWritePost,InsertLeave *.py setlocal filetype=python

let g:ale_python_flake8_executable = 'python3'   " or 'python' for Python 2
let g:ale_python_flake8_options = '-m flake8 --select F --ignore E402,E501'

fun! s:PythonVersion()
  if getline(1) =~# '^#!.*/bin/env\s\+python3\>'
    autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F5>   :w<CR>:!time python3 '%'            <CR>| endif
    autocmd vimrc BufEnter * if &filetype == 'python' |nmap <S-F5> :w<CR>:!time python3 '%' < '%:r.txt'<CR>| endif
    autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F9>   :w<CR>:!python3 -m flake8 '%'                 <CR>| endif
    let g:ale_python_flake8_executable = 'python3'
  else
    autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F5>   :w<CR>:!time python '%'            <CR>| endif
    autocmd vimrc BufEnter * if &filetype == 'python' |nmap <S-F5> :w<CR>:!time python '%' < '%:r.txt'<CR>| endif
    autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F9>   :w<CR>:!python -m flake8 '%'                 <CR>| endif
    let g:ale_python_flake8_executable = 'python2'
  endif
endfun

autocmd vimrc BufNewFile,BufRead *.py call s:PythonVersion()

":2 Python custom highlights
autocmd vimrc FileType python syn match DocKeyword "Returns" containedin=pythonString contained
autocmd vimrc FileType python syn match DocKeyword "Yields" containedin=pythonString contained
autocmd vimrc FileType python syn match DocKeyword "Usage" containedin=pythonString contained
autocmd vimrc FileType python syn match DocKeyword "Route" containedin=pythonString contained
autocmd vimrc FileType python syn match DocKeyword "Usage \d\." containedin=pythonString contained

" Highlight `%s %f %d %r`
autocmd vimrc FileType python syn match Comment "%\(s\|f\|d\|r\)"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `%.3f`
autocmd vimrc FileType python syn match Comment "%\.[0-9]\+f"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `%(word)s`
autocmd vimrc FileType python syn match Comment "%([a-zA-Z0-9_]\+)s"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `#Regular-word`
autocmd vimrc FileType python syn match Comment "\#[a-zA-Z0-9_-]\+"hs=s+0,he=e+0 containedin=pythonString contained
" Highlight `argument - `
autocmd vimrc FileType python syn match Comment "\s*[A-Za-z0-9_\-&\*:]*\(\s*- \)"he=e-2 containedin=pythonString contained
" Highlight `:Regular-word`
autocmd vimrc FileType python syn match Comment "\:[a-zA-Z0-9_-]\+"hs=s+0,he=e-0 containedin=pythonString contained

" Highlight `{Regular-word}`
autocmd vimrc FileType python syn match Type "{[a-zA-Z0-9_-]\+}"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `<Regular-word>`
autocmd vimrc FileType python syn match Type "<[a-zA-Z0-9_-]\+>"hs=s+0,he=e-0 containedin=pythonString contained

" Highlight `self.`
autocmd vimrc FileType python syn match Keyword "self\."

autocmd vimrc FileType python hi default link DocArgument HELP
" endfold

":1 Lua
":2 LuaFoldExpr
function! g:LuaFoldExpr()
  if getline(v:lnum) =~? '^end -- fold$'
    return '<1'
  endif

  if getline(v:lnum) =~? '^local function '
    return '>1'
  endif

  if getline(v:lnum) =~? '^function '
    return '>1'
  endif

  return '='
endfunction

":2 LuaFoldText
function! g:LuaFoldText()
  let l:line = getline(v:foldstart)

  return l:line

  if l:line =~? '^[a-z0-9-_]\+:'
    return l:line
  elseif l:line[:2] ==# '  #'
    return '  ▸ ' . l:line[4:]
  else
    return '▸   ' . l:line[4:]
  endif
endfunction
" endfold2

autocmd vimrc BufEnter *.script setlocal filetype=lua
autocmd vimrc FileType lua setlocal foldmethod=marker foldmarker=function\ ,end
autocmd vimrc FileType lua setlocal foldmethod=expr foldexpr=g:LuaFoldExpr() foldtext=g:LuaFoldText()

autocmd vimrc FileType lua syn match Keyword "self"

":1 Coffeescript
function! g:CoffeeFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
  return l:prefix . '▸   ' . l:trimmed
endfunction

autocmd vimrc FileType coffee setlocal foldmethod=marker foldmarker=#\:,endfold foldtext=g:CoffeeFoldText()

autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |nmap <F9>       :w<CR>:!coffee "%" --nodejs        <CR>| endif
autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |nmap <F5>       :w<CR>:!coffee -c -b -p "%" > "%:r"<CR>| endif
autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |nmap <C-s>      :w<CR>:!coffee -c -b -p "%" > "%:r"<CR>| endif
autocmd vimrc BufEnter *.js.coffee if &filetype == 'coffee' |imap <C-s> <ESC>:w<CR>:!coffee -c -b -p "%" > "%:r"<CR>| endif

":1 Javascript
":2 JavascriptFoldExpr
function! g:JavascriptFoldExpr()
  let l:trimmed = substitute(getline(v:lnum), '^\s*\(.\{-}\)\s*$', '\1', '')

  ":3 +1 | `//: `
  if l:trimmed =~? '^//: '
    return '>1'
  endif

  ":3 +1 | `//:1 `
  if l:trimmed =~? '^//:1 '
    return '>1'
  endif

  ":3 -1 | `// endfold`
  if l:trimmed =~? '^// endfold$'
    return '<1'
  endif
  " endfold

  ":3 +2 | `//:2 `
  if l:trimmed =~? '^//:2 '
    return '>2'
  endif

  ":3 -2 | `// endfold2`
  if l:trimmed =~? '^// endfold2'
    return '<2'
  endif
  " endfold
  "
  ":3 +3 | `//:2 `
  if l:trimmed =~? '^//:3 '
    return '>3'
  endif

  ":3 -3 | `// endfold3`
  if l:trimmed =~? '^// endfold3'
    return '<3'
  endif
  " endfold

  return '='
endfunction

":2 JavascriptFoldText
function! g:JavascriptFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
  return l:prefix . '▸   ' . l:trimmed
endfunction
" endfold

autocmd vimrc FileType javascript setlocal foldmethod=expr foldexpr=g:JavascriptFoldExpr() foldtext=g:JavascriptFoldText()
autocmd vimrc FileType javascript setlocal autoindent
autocmd vimrc BufEnter * if &filetype == 'javascript' |nmap <F5> :w<CR>:!time node "%" <CR>| endif

" Highlight `[selector]`
autocmd vimrc FileType javascript syn match Constant "\[[a-zA-Z0-9_-]\+=\"[a-zA-Z0-9_\ -]\+\"\]"hs=s+0,he=e-0 containedin=JsString contained
autocmd vimrc FileType javascript syn match Constant "\[[a-zA-Z0-9_\=-]\+\]"hs=s+0,he=e-0 containedin=JsString contained

":1 Java
autocmd vimrc FileType java setlocal foldmethod=marker foldmarker=BEGIN\ CUT\ HERE,END\ CUT\ HERE

autocmd vimrc BufEnter * if &filetype == 'java' |nmap <F5>   :w<CR>:!javac "%"; java "%:t:r";             rm -f "%:r.class" "%:rHarness.class"<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'java' |nmap <S-F5> :w<CR>:!javac "%"; java "%:t:r" < input.txt; rm -f "%:r.class" "%:rHarness.class"<CR>| endif


" endfold

":1 Makefile
":2 MakefileFoldExpr
function! g:MakefileFoldExpr()
  " Case: start with 'COMMAND:'
  if getline(v:lnum) =~? '^[a-z0-9-_]\+:$'
    return '>1'
  endif
  if getline(v:lnum) =~? '^# endfold$'
    return '<1'
  endif

  return '='
endfunction

":2 MakefileFoldText
function! g:MakefileFoldText()
  return strpart(getline(v:foldstart), 0, strlen(getline(v:foldstart)) - 1)
endfunction
" endfold

autocmd vimrc FileType make setlocal foldmethod=expr foldexpr=g:MakefileFoldExpr() foldtext=g:MakefileFoldText()

":1 C#
function! g:CSFoldText()
  return getline(v:foldstart)
endfunction

autocmd vimrc FileType cs setlocal foldmethod=marker foldtext=g:CSFoldText()
autocmd vimrc FileType cs setlocal foldmarker=//\:,endfold

":1 C
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <F9>   :w<CR>:!gcc "%" -Wall -lm -o "%:p:h/a"<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <F5>   :w<CR>:!time "%:p:h/a"                <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt    <CR>| endif

":1 C++
":2 CppFoldText
function! g:CppFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)

  let l:nucolwidth = &foldcolumn + &number * &numberwidth
  let l:windowwidth = winwidth(0) - l:nucolwidth - 3
  let l:foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let l:onetab = strpart('          ', 0, &tabstop)
  let l:line = substitute(l:line, '\t', l:onetab, 'g')

  let l:line = strpart(l:line, l:leading_spaces * &tabstop + 12, l:windowwidth - 2 -len(l:foldedlinecount))
  let l:fillcharcount = l:windowwidth - len(l:line) - len(l:foldedlinecount)
  return repeat(l:onetab, l:leading_spaces). '▸' . printf('%3s', l:foldedlinecount) . ' lines ' . l:line . '' . repeat(' ', l:fillcharcount) . '(' . l:foldedlinecount . ')' . ' '
endfunction
" endfold

autocmd vimrc FileType cpp setlocal foldmethod=marker foldmarker=\/\/\ created\:,\/\/\ end
autocmd vimrc FileType cpp setlocal foldtext=g:CppFoldText()

autocmd vimrc BufEnter * if &filetype == 'cpp' |nmap <F9>   :w<CR>:!g++ "%" -std=c++11 -Wall -o "%:p:h/%:r" -O3<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'cpp' |nmap <F5>   :w<CR>:!time "%:p:h/%:r"             <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'cpp' |nmap <S-F5> :w<CR>:!time "%:p:h/%:r" < "%:r.txt" <CR>| endif

autocmd vimrc FileType cpp syn keyword normal long
autocmd vimrc FileType cpp syn keyword normal float
autocmd vimrc FileType cpp syn keyword cType string
autocmd vimrc FileType cpp syn keyword cType Vector
autocmd vimrc FileType cpp syn keyword cType Pair
autocmd vimrc FileType cpp syn keyword cType Set
autocmd vimrc FileType cpp syn keyword cType Long
autocmd vimrc FileType cpp syn keyword cType stringstream
autocmd vimrc FileType cpp syn keyword cRepeat For Rep
autocmd vimrc FileType cpp syn match cComment /;/

":1 PHP
":2 PHPFoldExpr
function! g:PHPFoldExpr()
  ":3 Variable reset
  if v:lnum == 1
    let s:fold = 0           " fold level
    let s:fold_1_start = ''
  endif
  " endfold

  ":3 +1 | <indent> function start
  if getline(v:lnum) =~? '^\s\{4\}public function '
    let s:fold = 1
    let s:fold_1_start = 'public function'
    return '>1'
  endif

  if getline(v:lnum) =~? '^\s\{4\}private function '
    let s:fold = 1
    let s:fold_1_start = 'private function'
    return '>1'
  endif

  if getline(v:lnum) =~? '^\s\{4\}public static function '
    let s:fold = 1
    let s:fold_1_start = 'public static function'
    return '>1'
  endif

  if getline(v:lnum) =~? '^\s\{4\}final public function '
    let s:fold = 1
    let s:fold_1_start = 'final public function'
    return '>1'
  endif

  if getline(v:lnum) =~? '^\s\{4\}function '
    let s:fold = 1
    let s:fold_1_start = 'function'
    return '>1'
  endif

  ":3 -1 | <indent> function close (type change)
  if getline(v:lnum) =~# '^\s\{4\}}'
  if getline(v:lnum + 2) =~# '^\s\{4\}public function '
  if s:fold_1_start !=# 'public function'
    let s:fold = 0
    return '<1'
  endif
  endif
  endif

  if getline(v:lnum) =~# '^\s\{4\}}'
  if getline(v:lnum + 2) =~# '^\s\{4\}private function '
  if s:fold_1_start !=# 'private function'
    let s:fold = 0
    return '<1'
  endif
  endif
  endif

  if getline(v:lnum) =~# '^\s\{4\}}'
  if getline(v:lnum + 2) =~# '^\s\{4\}public static function '
  if s:fold_1_start !=# 'public static function'
    let s:fold = 0
    return '<1'
  endif
  endif
  endif

  if getline(v:lnum) =~# '^\s\{4\}}'
  if getline(v:lnum + 2) =~# '^\s\{4\}final public function '
    if s:fold_1_start !=# 'final public function'
    let s:fold = 0
    return '<1'
  endif
  endif
  endif

  if getline(v:lnum) =~# '^\s\{4\}}'
  if getline(v:lnum + 2) =~# '^\s\{4\}function '
  if s:fold_1_start !=# 'function'
    let s:fold = 0
    return '<1'
  endif
  endif
  endif

  ":3 -1 | <indent> function close (next is comment)
  if getline(v:lnum) =~# '^\s\{4\}}'
  if getline(v:lnum + 1) =~# ''
  if getline(v:lnum + 2) =~# '//'
  if s:fold ==# 1 && s:fold_1_start !=# '1_title'
    let s:fold = 0
    return '<1'
  endif
  endif
  endif
  endif

  ":3 -1 | <indent> function close (last)
  if getline(v:lnum) =~# '^\s\{4\}}'
  if getline(v:lnum + 1) =~# '^}'
    let s:fold = 1
    return '<1'
  endif
  endif

  ":3 +1 | // title
  if getline(v:lnum) =~# '^\s\{4,\}// [A-Z0-9\e]'
  if s:fold == 0
      let s:fold_1_start = '1_title'
      return '>1'
  endif
  endif

  ":3 -1 | // endfold
  if getline(v:lnum) =~# '^\s\{4\}// endfold'
    let s:fold = 0
    return '<1'
  endif
  " endfold

  ":3 +2 | // title
  if getline(v:lnum) =~# '^\s\{8,\}// [A-Z0-9\e]'
    if s:fold == 0
      return '>1'
    endif
    if s:fold == 1
      return '>2'
    endif
  endif

  ":3 -2 | // endfold
  if getline(v:lnum) =~# '^\s\{8,\}// endfold'
    if s:fold == 1
      return '<2'
    endif
    if s:fold == 2
      return '<3'
    endif
  endif
  " endfold

  return '='
endfunction
" endfold
":2 PHPFoldText
function! g:PHPFoldText()
  let l:line = getline(v:foldstart)
  return l:line

  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
  return l:prefix . '▸ ' . l:line
  return l:prefix . '▸   ' . l:trimmed
endfunction
" endfold

autocmd vimrc FileType php setlocal foldmethod=expr foldexpr=g:PHPFoldExpr() foldtext=g:PHPFoldText()
autocmd vimrc BufEnter * if &filetype == 'php' |nmap <F5> :w<CR>:!time php "%"<CR>|endif
autocmd vimrc BufEnter * if &filetype == 'php' |nmap <F9> :w<CR>:!php -l '%'<CR>| endif

" Highlight `#Regular-word`
autocmd vimrc FileType php syn match Comment "\#[a-zA-Z0-9_-]\+"hs=s+0,he=e+0 containedin=phpStringSingle contained

":1 Markdown: simple todo-list manager
function! MarkdownToggle()
  let l:line = getline('.')

  " GitHub task friendly todo-list
  if match(l:line, '^\s*- \[ \]') == 0
    let l:line = substitute(l:line, '^\(\s*\)- \[ \]s*', '\1- \[x\]', '')
  elseif match(l:line, '^\s*- \[x\]') == 0
    let l:line = substitute(l:line, '^\(\s*\)- \[x\]s*', '\1- \[ \]', '')

  " Simple todo-list
  elseif match(l:line, '^\s*- +') == 0
    let l:line = substitute(l:line, '^\(\s*\)- +\s*', '\1- ✓ ', '')
  elseif match(l:line, '^\(\s*\)- ✓') == 0
    let l:line = substitute(l:line, '^\(\s*\)- ✓\s*', '\1- ✗ ', '')
  elseif match(l:line, '^\(\s*\)- ✗') == 0
    let l:line = substitute(l:line, '^\(\s*\)- ✗\s*', '\1- ', '')
  elseif match(l:line, '^\s*-') == 0
    let l:line = substitute(l:line, '^\(\s*\)-\s*', '\1- + ', '')
  endif

  call setline('.', l:line)
endfunction

" GUI version
nmap <C-Space> :call MarkdownToggle()<CR>
vmap <C-Space> :call MarkdownToggle()<CR>

" Terminal version
nmap <C-@> :call MarkdownToggle()<CR>
vmap <C-@> :call MarkdownToggle()<CR>

autocmd vimrc FileType markdown syn match TodoLine '^\s*\-\(\n\s\+[^- ].*\)*'
autocmd vimrc FileType markdown syn match OpenLine '^\s*\- +.*\(\n\s\+[^- ].*\)*'
autocmd vimrc FileType markdown syn match DoneLine '^\s*\- ✓.*\(\n\s\+[^- ].*\)*'
autocmd vimrc FileType markdown syn match SkipLine '^\s*\- ✗.*\(\n\s\+[^- ].*\)*'

autocmd vimrc FileType markdown syn match DoneLine '^\s*\- \[x\].*\(\n\s\+[^- ].*\)*'

autocmd vimrc FileType markdown hi def link TodoLine Normal
autocmd vimrc FileType markdown hi def link OpenLine String
autocmd vimrc FileType markdown hi def link DoneLine htmlTagName
autocmd vimrc FileType markdown hi def link SkipLine Comment
" endfold

":1 HTML, HTML-jinja
":2 HTMLFoldExpr
function! g:HTMLFoldExpr()
  let l:trimmed = substitute(getline(v:lnum), '^\s*\(.\{-}\)\s*$', '\1', '')

  ":3 +1 | `{% macro `
  if getline(v:lnum) =~? '^{% macro '
    return '>1'
  endif

  if getline(v:lnum) =~? '^{%- macro '
    return '>1'
  endif

  ":3 +1 | `{% call `
  if getline(v:lnum) =~? '^{% call '
    return '>1'
  endif

  if getline(v:lnum) =~? '^{%- call '
    return '>1'
  endif

  ":3 +1 | `#: `
  if l:trimmed =~? '^#: '
    return '>1'
  endif

  ":3 +1 | `<!--: `
  if l:trimmed =~? '^<!--: '
    return '>1'
  endif


  ":3 -1 | `<!-- endfold -->`
  if l:trimmed =~? '^<!-- endfold -->'
    return '<1'
  endif

  ":3 -1 | `#:endfold`
  if l:trimmed =~? '^#:endfold$'
    return '<1'
  endif

  ":3 +1 | `{#: `
  if l:trimmed =~? '^{#: '
    return '>1'
  endif

  ":3 -1 | `{#:endfold #}`
  if l:trimmed =~? '^{#:endfold #}$'
    return '<1'
  endif
  " endfold

  ":3 +2 | `#:2`
  if l:trimmed =~? '^#:2'
    return '>2'
  endif

  ":3 -2 | `#:endfold2`
  if l:trimmed =~? '^#:endfold2'
    return '<2'
  endif

  ":3 +2 | `{#:2 `
  if l:trimmed =~? '^{#:2 '
    return '>2'
  endif

  ":3 -2 | `{#:endfold2 #}`
  if l:trimmed =~? '^{#:endfold2 #}'
    return '<2'
  endif

  ":3 +2 | `{% call `
  if getline(v:lnum) =~? '  {% call '
    return '>2'
  endif

  if getline(v:lnum) =~? '  {%- call '
    return '>2'
  endif
  " endfold

  return '='
endfunction

":2 HTMLFoldText
function! g:HTMLFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  if l:trimmed[:3] ==# '#: <'
    return l:prefix . '' . l:trimmed[3:]
  elseif l:trimmed[:4] ==# '#:2 <'
    return l:prefix . '' . l:trimmed[4:]
  elseif l:trimmed[:1] ==# '{%'
    return l:prefix . l:trimmed
  elseif l:trimmed[:2] ==# '{#:'
    let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
    let l:trimmed = substitute(l:trimmed, '{', '', 'g')
    let l:trimmed = substitute(l:trimmed, '#', '', 'g')
    let l:trimmed = substitute(l:trimmed, '}', '', 'g')
    return l:prefix . '▸   ' . l:trimmed
  elseif l:trimmed[:1] ==# '{#'
    let l:trimmed = strpart(l:trimmed, 5, l:size - 5)
    let l:trimmed = substitute(l:trimmed, '{', '', 'g')
    let l:trimmed = substitute(l:trimmed, '#', '', 'g')
    let l:trimmed = substitute(l:trimmed, '}', '', 'g')
    return l:prefix . l:trimmed
  elseif l:trimmed[0] ==# '#'
    let l:trimmed = strpart(l:trimmed, 3, l:size - 3)
    let l:trimmed = substitute(l:trimmed, '{', '', 'g')
    let l:trimmed = substitute(l:trimmed, '#', '', 'g')
    let l:trimmed = substitute(l:trimmed, '}', '', 'g')
    return l:prefix . '▸  ' . l:trimmed
  else
    return l:prefix . l:trimmed
  endif
endfunction
" endfold

autocmd vimrc BufNewFile,BufRead *.html setlocal filetype=htmljinja
autocmd vimrc FileType htmljinja setlocal foldmethod=expr foldexpr=g:HTMLFoldExpr() foldtext=g:HTMLFoldText()
autocmd vimrc FileType htmljinja setlocal textwidth=159
autocmd vimrc FileType htmljinja match OverLength /\%160v.\+/

" Jinja line comment
autocmd vimrc FileType htmljinja syn region jinjaComment matchgroup=jinjaCommentDelim start="#:" end="$" keepend containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

" Inline math. Example: Pythagorean $a^2 + b^2 = c^2$
autocmd vimrc FileType htmljinja syn region mathjax start=/\s*$[^$]*/ end=/[^$]*$\s*/

" Display math. Example: Quadratic Equations $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$
autocmd vimrc FileType htmljinja syn region mathjax start=/\s*$$[^$]*/ end=/[^$]*$$\s*/

autocmd vimrc FileType htmljinja hi def link mathjax Comment

":1 Shell script
function! g:ShellFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
  return l:prefix . '▸   ' . l:trimmed
endfunction

autocmd vimrc BufEnter * if &filetype == 'sh' |nmap <F5> :w<CR>:!bash "%"<CR>| endif
autocmd vimrc FileType sh,zsh setlocal foldmethod=marker foldmarker=#:,#\ endfold foldtext=ShellFoldText()

":1 CSS
autocmd vimrc FileType css setlocal foldmethod=marker foldmarker=\/*:,\/*\ endfold\ *\/

":1 Sass
function! g:SassFoldText()
  return getline(v:foldstart)
endfunction

function! g:SassFoldExpr()
  let l:line = getline(v:lnum)

  ":2 +1 | selector
  if l:line =~# '^[^ ]' && getline(v:lnum + 1) =~# '^  '
    return '>1'
  endif

  ":2 -1 | \n\n
  if l:line =~# '^$' && getline(v:lnum + 1) =~# '^$'
    return '<1'
  endif

  ":2 -1 | // endfold
  if l:line =~# '^// endfold'
    return '<1'
  endif
  " endfold

  ":2 +2 | ..selector
  " ..x
  " ....x
  if l:line =~# '^  [^ ]' && getline(v:lnum + 1) =~# '^    '
    return '>2'
  endif

  ": 2 + | ..// endfold
  " ..// endfold
  if l:line =~# '^  // endfold'
    return '<2'
  endif

  ":2 -2 | ....(last)
  " ....x
  " |
  " x
  if l:line =~# '^    ' && getline(v:lnum + 1) =~# '^$' && getline(v:lnum + 2) =~# '^[^ ]'
    return '<2'
  endif
  " endfold

  return '='
endfunction

let g:ale_sass_stylelint_executable = 'sasslint'

autocmd vimrc FileType sass setlocal foldmethod=expr foldexpr=g:SassFoldExpr() foldtext=g:SassFoldText()
autocmd vimrc FileType sass setlocal iskeyword-=#,-
autocmd vimrc FileType sass setlocal iskeyword+=$

":1 Other
autocmd vimrc BufEnter Rakefile nmap <F5> :w<CR>:!rake<CR>
autocmd vimrc BufEnter Makefile nmap <F5> :w<CR>:!make<CR>

autocmd vimrc FileType help nnoremap <buffer> <CR> <C-]>
autocmd vimrc FileType help nnoremap <buffer> <BS> <C-T>
" endfold

":1 Filetype detection
autocmd vimrc BufEnter *.gitignore setlocal filetype=gitconfig
autocmd vimrc BufEnter *.conf setlocal filetype=dosini

":1 Remove trailing spaces
autocmd vimrc BufWritePre *.py,*.html,*.js,*.sass,*.vim
  \ :%s/\s\+$//e

":1 Tab configuration for filetypes
" use tab. tabsize = 2
autocmd vimrc FileType java,snippets,make
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab

" no tab use. tab = 4 space
autocmd vimrc FileType python,sh,php,cs
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" no tab use. tab = 2 space
" (all others)
