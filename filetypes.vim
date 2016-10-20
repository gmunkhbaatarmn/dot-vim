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
      return '>1'
    endif
    endif

    ":3 =1 | import lines middle
    if getline(v:lnum - 1) =~? '^\(from\|import\) '
    if getline(v:lnum + 0) =~? '^\(from\|import\) '
      return '='
    endif
    endif

    ":3 -1 | import lines close
    if getline(v:lnum - 1) =~? '^\(from\|import\) '
    if getline(v:lnum - 0) !~? '^\(from\|import\) '
      return '<1'
    endif
    endif
    " endfold

    ":3 +1 | decorator start
    if getline(v:lnum) =~? '^@'
      let s:fold = 1
      return '>1'
    endif

    ":3 =1 | decorator's next line
    if getline(v:lnum - 1) =~? '^@'
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

  if l:trimmed =~# '^@classmethod'
    let l:custom_text = '@classmethod ' . substitute(strpart(l:nextline_trimmed, 4), ':', '', '') . ''

  elseif l:trimmed =~# '^\(from \|import \)'
    let l:custom_text = 'import'

  elseif l:trimmed =~# '^step'
    let l:custom_text = l:trimmed
    let l:custom_text = substitute(l:custom_text, '(', '', '')
    let l:custom_text = substitute(l:custom_text, '"', '', '')
    let l:custom_text = substitute(l:custom_text, ')', '', '')
    let l:custom_text = substitute(l:custom_text, '\\n', '', '')

    let l:custom_text = '▸     ' . l:custom_text[4:]

  elseif l:trimmed =~# '^@task'
    let l:custom_text = '@task ' . strpart(l:nextline_trimmed, 4, strlen(l:nextline_trimmed) - 5)

  elseif l:trimmed =~# '^@cron'
    let l:custom_text = '@cron ' . strpart(l:nextline_trimmed, 4, strlen(l:nextline_trimmed) - 5)

  elseif l:trimmed =~# '^@property'
    let l:custom_text = '@property ' . strpart(split(l:nextline_trimmed, '(')[0], 4)

  elseif l:trimmed =~# '\.setter$'
    let l:after_part = substitute(l:nextline_trimmed, ':', '', '')
    let l:custom_text = 'def @' . strpart(substitute(l:after_part, '(', '.setter(', ''), 4)

  elseif l:trimmed =~# '@'
    let l:fillcharcount = 80 - len(l:prefix) - len(substitute(l:trimmed, '.', '-', 'g'))
    let l:custom_text = '@' . strpart(l:trimmed, 1) . repeat(' ', l:fillcharcount) . substitute(l:nextline_trimmed, ':', '', '')

  elseif l:trimmed =~# '^# [A-Z0-9-]'
    let l:custom_text = '▸ ' . strpart(l:trimmed, 2)

  elseif l:trimmed =~# '^def test_'
    let l:custom_text = l:trimmed
    let l:custom_text = substitute(l:custom_text, '(', '', '')
    let l:custom_text = substitute(l:custom_text, ')', '', '')
    let l:custom_text = 'def test ' . substitute(strpart(l:custom_text, 9), ':', ' ', '')

  elseif l:trimmed =~# '^def '
    let l:custom_text = 'def ' . substitute(strpart(l:trimmed, 4), ':', ' ', '')

  elseif l:trimmed =~# '^class '
    let l:custom_text = 'class ' . substitute(strpart(l:trimmed, 6), ':', '', '')

  elseif l:trimmed =~# '^if '
    let l:custom_text = 'if ' . substitute(strpart(l:trimmed, 3), ':', '', '')

  elseif l:trimmed =~# '^for '
    let l:custom_text = 'for ' . substitute(strpart(l:trimmed, 4), ':', '', '')

  elseif l:trimmed =~# '^while '
    let l:custom_text = 'while ' . substitute(strpart(l:trimmed, 6), ':', ' ', '')

  elseif l:trimmed =~# '^try:'
    let l:custom_text = 'try' . substitute(strpart(l:trimmed, 3), ':', ' ', '')

  elseif l:trimmed =~# '^except:'
    let l:custom_text = 'except' . substitute(strpart(l:trimmed, 7), ':', ' ', '')

  elseif l:trimmed =~# '^except '
    let l:custom_text = 'except ' . substitute(strpart(l:trimmed, 7), ':', ' ', '')

  elseif l:trimmed =~# '^finally:'
    let l:custom_text = 'finally' . substitute(strpart(l:trimmed, 7), ':', ' ', '')

  else
    return foldtext()
  endif

  return l:prefix . l:custom_text
endfunction
" endfold

autocmd vimrc FileType python setlocal foldmethod=expr foldexpr=g:PythonFoldExpr() foldtext=g:PythonFoldText()
autocmd vimrc FileType python setlocal textwidth=119
autocmd vimrc BufWritePost,InsertLeave *.py setlocal filetype=python

autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F5>   :w<CR>:!time python '%'            <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'python' |nmap <S-F5> :w<CR>:!time python '%' < input.txt<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'python' |nmap <F9>   :w<CR>:!flake8 '%'                 <CR>| endif

" Show line in 80th column
autocmd vimrc FileType python highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd vimrc FileType python match OverLength /\%80v.\+/

":2 Python custom highlights
autocmd vimrc FileType python syn match DocKeyword "Returns" containedin=pythonString contained
autocmd vimrc FileType python syn match DocKeyword "Usage" containedin=pythonString contained
autocmd vimrc FileType python syn match DocKeyword "Route" containedin=pythonString contained
autocmd vimrc FileType python syn match DocKeyword "Usage \d\." containedin=pythonString contained
" Highlight `CAPITALIZED:`
autocmd vimrc FileType python syn match DocKeyword "\s*[A-Z]\+\(\s\|\n\)"he=e-1 containedin=pythonString contained
" Highlight `{Regular-word}`
autocmd vimrc FileType python syn match DocKeyword "{[a-zA-Z0-9_-]\+}"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `%(word)s`
autocmd vimrc FileType python syn match DocKeyword "%([a-zA-Z0-9_]\+)s"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `%s`
autocmd vimrc FileType python syn match DocKeyword "%\(s\|f\|d\)"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `%.3f`
autocmd vimrc FileType python syn match DocKeyword "%\.[0-9]\+f"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `:Regular-word`
autocmd vimrc FileType python syn match DocKeyword "\:[a-zA-Z0-9_-]\+"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `#Regular-word`
autocmd vimrc FileType python syn match DocKeyword "\#[a-zA-Z0-9_-]\+"hs=s+0,he=e-0 containedin=pythonString contained
" Highlight `self.`
autocmd vimrc FileType python syn match Keyword "self\."

" Highlight `argument - `
autocmd vimrc FileType python syn match DocArgument "\s*[A-Za-z0-9_\-&\*:]*\(\s*- \)"he=e-2 containedin=pythonString contained

autocmd vimrc FileType python hi default link DocArgument HELP
autocmd vimrc FileType python hi default link DocKeyword Comment
" endfold

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
function! g:VimFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
  return l:prefix . '▸   ' . l:trimmed
endfunction
autocmd vimrc FileType vim setlocal foldmethod=marker foldmarker=\"\:,\"\ endfold foldtext=g:VimFoldText()

autocmd vimrc FileType vim syn match DocKeyword "\\." containedin=vimString contained
autocmd vimrc FileType vim hi default link DocKeyword Comment

":1 Yaml
function! g:YamlFoldText()
  let l:line = getline(v:foldstart)

  if l:line =~? '^[a-z0-9-_]\+:'
    return l:line
  elseif l:line[:2] ==# '  #'
    return '  ▸ ' . l:line[4:]
  else
    return '▸   ' . l:line[4:]
  endif
endfunction

function! g:YamlFoldExpr()
  if getline(v:lnum) =~? '^# endfold$'
    return '<1'
  endif

  if getline(v:lnum) =~? '^[a-z0-9-_]\+:'
    return '>1'
  endif

  if getline(v:lnum) =~? '^  # -'
    return '>2'
  endif

  return '='
endfunction

autocmd vimrc FileType yaml setlocal foldmethod=expr foldexpr=g:YamlFoldExpr() foldtext=g:YamlFoldText()
autocmd vimrc FileType yaml setlocal foldmarker=#\:,endfold
autocmd vimrc FileType yaml highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd vimrc FileType yaml match OverLength /\%120v.\+/

":1 Makefile
function! g:MakefileFoldExpr()
  " Case: start with 'COMMAND:'
  if getline(v:lnum) =~? '^[a-z-_]\+:$'
    return '>1'
  endif

  return '='
endfunction

autocmd vimrc FileType make setlocal foldmethod=expr foldexpr=g:MakefileFoldExpr() foldtext=strpart(getline(v:foldstart),0,strlen(getline(v:foldstart))-1)

":1 C
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <F9>   :w<CR>:!gcc "%" -Wall -lm -o "%:p:h/a"<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <F5>   :w<CR>:!time "%:p:h/a"                <CR>| endif
autocmd vimrc BufEnter * if &filetype == 'c' |nmap <S-F5> :w<CR>:!time "%:p:h/a" < input.txt    <CR>| endif

":1 C++
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

autocmd vimrc FileType cpp setlocal foldmethod=marker foldmarker=\/\/\ created\:,\/\/\ end
autocmd vimrc FileType cpp setlocal foldtext=g:CppFoldText()

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
autocmd vimrc BufEnter Notes     setlocal filetype=markdown
autocmd vimrc BufEnter Roadmap   setlocal filetype=markdown
autocmd vimrc BufEnter Greatness setlocal filetype=markdown

":2 MarkdownFoldText
function! g:MarkdownFoldText()
  let l:text = getline(v:foldstart)
  let l:text = '▸' . l:text[1:]
  let l:text = substitute(l:text, '#', ' ', 'g')

  return l:text
endfunction

":2 MarkdownFoldExpr
function! g:MarkdownFoldExpr()
  let l:line = getline(v:lnum)

  if getline(v:lnum) ==# '> endfold'
    return '<1'
  endif

  " Regular headers
  let l:depth = match(l:line, '\(^#\+\)\@<=\( .*$\)\@=')
  if l:depth > 0
    return '>' . l:depth
  endif

  return '='
endfunction
" endfold

autocmd vimrc BufEnter * if &filetype == 'markdown' |nmap <F5> :w<CR>:!html-book "%"; open "%:r.html"<CR>;|endif
autocmd vimrc BufEnter * if &filetype == 'markdown' |nmap <F9> :w<CR>:!pdf-book "%"; open "%:r.pdf"<CR>;|endif
autocmd vimrc FileType markdown setlocal foldmethod=expr foldexpr=g:MarkdownFoldExpr() foldtext=g:MarkdownFoldText()

":2 Markdown: syntax enhancements
" Expression: $...$
autocmd vimrc FileType markdown syn region Function start=/\s*$[^$]*/ end=/[^$]*$\s*/

" Expression: $$...$$
autocmd vimrc FileType markdown syn region Function start=/\s*$$[^$]*/ end=/[^$]*$$\s*/

" Expression: `...`
autocmd vimrc FileType markdown syn region String start=/\s*`[^`]*/ end=/[^`]*`\s*/

" Expression: #123 (github issue number)
autocmd vimrc FileType markdown syn match Function '#[0-9]\+' containedin=TodoLine

" Expression: @name
autocmd vimrc FileType markdown syn match Function '\s@[a-z]\+' containedin=TodoLine

" Feature: list label
autocmd vimrc FileType markdown syn match ListLabel '[^\[\]\(\)\ ]\+:' containedin=TodoLine
autocmd vimrc FileType markdown hi def link ListLabel Float

" Fix: underline fix
autocmd vimrc FileType markdown syn match Text "\w\@<=_\w\@="

" Fix: syntax bug fix
autocmd vimrc FileType markdown syn region htmlBold start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contains=markdownLineStart
autocmd vimrc FileType markdown syn region markdownBoldItalic start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contains=markdownLineStart
autocmd vimrc FileType markdown syn region markdownBoldItalic start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contains=markdownLineStart

":2 Markdown: simple todo-list manager
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
function! g:HTMLFoldText()
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  if l:trimmed[0] ==# '{'
    let l:trimmed = strpart(l:trimmed, 5, l:size - 5)
    let l:trimmed = substitute(l:trimmed, '{', '', 'g')
    let l:trimmed = substitute(l:trimmed, '#', '', 'g')
    let l:trimmed = substitute(l:trimmed, '}', '', 'g')
    return l:prefix . l:trimmed
  else
    let l:trimmed = strpart(l:trimmed, 3, l:size - 3)
    let l:trimmed = substitute(l:trimmed, '{', '', 'g')
    let l:trimmed = substitute(l:trimmed, '#', '', 'g')
    let l:trimmed = substitute(l:trimmed, '}', '', 'g')
    return l:prefix . '▸  ' . l:trimmed
  endif
endfunction

autocmd vimrc BufNewFile,BufRead *.html setlocal filetype=htmljinja
autocmd vimrc FileType htmljinja setlocal foldmethod=marker foldmarker=#\:,endfold foldtext=g:HTMLFoldText()

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

":1 Stylus
function! g:StylusFoldText()
  return getline(v:foldstart)
endfunction

function! g:StylusFoldExpr()
  let l:line = getline(v:lnum)
  if l:line =~# '^ '
    return '='
  endif

  if getline(v:lnum + 1) !~? '\v\S'
  if getline(v:lnum + 2) !~? '\v\S'
    return '<1'
  endif
  endif

  if l:line =~# '^@import'
    return '='
  endif

  if l:line =~# '^$'
    return '='
  endif

  if l:line =~# '^// endfold'
    return '<1'
  endif

  return '>1'
endfunction

autocmd vimrc FileType stylus setlocal foldmethod=expr foldexpr=g:StylusFoldExpr() foldtext=g:StylusFoldText()
autocmd vimrc FileType stylus setlocal iskeyword-=#
autocmd vimrc FileType stylus setlocal iskeyword+=$

autocmd vimrc BufEnter *.css.styl if &filetype == 'stylus' |nmap <C-s>      :w<CR>:!stylus -u nib --include-css -p "%" > "%:r"; sed -i -e '1i/* Generated by Stylus '`stylus --version`' */\' "%:r"<CR>| endif
autocmd vimrc BufEnter *.css.styl if &filetype == 'stylus' |imap <C-s> <ESC>:w<CR>:!stylus -u nib --include-css -p "%" > "%:r"; sed -i -e '1i/* Generated by Stylus '`stylus --version`' */\' "%:r"<CR>| endif
autocmd vimrc BufEnter *.css.styl if &filetype == 'stylus' |nmap <F5>       :w<CR>:!stylus -u nib --include-css -p "%" > "%:r"; sed -i -e '1i/* Generated by Stylus '`stylus --version`' */\' "%:r"<CR>| endif

":1 Snippets
autocmd vimrc FileType snippets setlocal foldmethod=expr foldtext=getline(v:foldstart)
autocmd vimrc FileType snippets setlocal foldexpr=((getline(v:lnum)=~?'snippet\ ')?'>1':'1')

":1 Other
autocmd vimrc BufEnter Rakefile nmap <F5> :w<CR>:!rake<CR>
autocmd vimrc BufEnter Makefile nmap <F5> :w<CR>:!make<CR>

autocmd vimrc FileType help nnoremap <buffer> <CR> <C-]>
autocmd vimrc FileType help nnoremap <buffer> <BS> <C-T>
" endfold

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
autocmd vimrc FileType cucumber,css,vim,json,javascript,stylus,yaml,markdown,ruby,coffee,htmljinja,treetop
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" endfold
