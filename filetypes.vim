scriptencoding utf-8

" For each FileType:
"
"   - General
"   - Tab
"   - Fold
"   - Mapping
"   - Syntax

" General purpose usage
":1 FileType: Markdown
Plugin 'plasticboy/vim-markdown'
Plugin 'rhysd/vim-gfm-syntax'

let g:vim_markdown_folding_disabled = 1           " Disable header fold
let g:vim_markdown_override_foldtext = 0          " Disable plugin's fold text
let g:vim_markdown_frontmatter = 1                " Enable YAML header
let g:vim_markdown_auto_insert_bullets = 0        " Disabled due problems when wrapping text

function! g:MarkdownFoldExpr()
  ":2 ...
  " Variable reset
  if v:lnum == 1
    let s:in_fencedoc = 0  " in fence doc
  endif

  let l:line = getline(v:lnum)

  if s:in_fencedoc
    " close fence doc
    if l:line =~? '```'
      let s:in_fencedoc = 0
    endif
    return '='
  else
    " start fence doc
    if l:line =~? '```'
      let s:in_fencedoc = 1
      return '='
    endif
  endif

  if getline(v:lnum) ==# '> endfold'
    return '<1'
  endif

  if getline(v:lnum) ==# '<!-- endfold -->'
    return '<1'
  endif

  " Regular headers
  if getline(v:lnum) ==# '---'
    return '>1'
  endif

  " Regular headers
  let l:depth = match(l:line, '\(^#\+\)\@<=\( .*$\)\@=')
  if l:depth > 0 && l:depth <= 1
    return '>' . l:depth
  endif

  return '='
  " endfold2
endfunction

function! g:MarkdownFoldText2()
  ":2 ...
  " function name `MarkdownFoldText` is already defined
  let l:text = getline(v:foldstart)
  if l:text ==# '---'
    let l:text = getline(v:foldstart + 1)
  endif

  let l:text = '▸' . l:text[1:]
  " let l:text = substitute(l:text, '#', ' ', 'g')

  return l:text
  " endfold2
endfunction

autocmd vimrc FileType markdown
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:MarkdownFoldExpr()
  \ | setlocal foldtext=g:MarkdownFoldText2()
" endfold

" General programming
":1 FileType: Python
Plugin 'vim-python/python-syntax'
Plugin 'Vimjas/vim-python-pep8-indent'

" ENV variables for GUI
let $PYTHONDONTWRITEBYTECODE = 1
let $PYTHONIOENCODING = 'utf-8'

let g:python_highlight_all = 1
let g:python_slow_sync = 0

let g:ale_linters['python'] = ['flake8']
let g:ale_python_flake8_executable = 'python_universal'
let g:ale_python_flake8_options = '-m flake8 --select F --ignore E402,E501'

function! g:PythonFoldExpr()
  ":2 ...
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
    if getline(v:lnum) =~? '.*"""'
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
  " endfold2
endfunction

function! g:PythonFoldText()
  ":2 ...
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
  " endfold2
endfunction

autocmd vimrc FileType python
  \   setlocal tabstop=4
  \ | setlocal shiftwidth=4
  \ | setlocal expandtab

autocmd vimrc FileType python
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:PythonFoldExpr()
  \ | setlocal foldtext=g:PythonFoldText()

autocmd vimrc FileType python
  \ nmap <buffer> <F5>   :w<CR>:!time python_universal '%'            <CR>
autocmd vimrc FileType python
  \ nmap <buffer> <S-F5> :w<CR>:!time python_universal '%' < '%:r.txt'<CR>
autocmd vimrc FileType python
  \ nmap <buffer> <F9>   :w<CR>:!python_universal -m flake8 '%'       <CR>

":2 Highlight: `%s %f %d %r`
autocmd vimrc FileType python
  \ syntax match Comment "%\(s\|f\|d\|r\)"hs=s+0,he=e-0
  \ containedin=pythonString contained

":2 Highlight: `%.3f`
autocmd vimrc FileType python
  \ syntax match Comment "%\.[0-9]\+f"hs=s+0,he=e-0
  \ containedin=pythonString contained

":2 Highlight: `%(word)s`
autocmd vimrc FileType python
  \ syntax match Comment "%([a-zA-Z0-9_]\+)s"hs=s+0,he=e-0
  \ containedin=pythonString contained

":2 Highlight: `#Regular-word`
autocmd vimrc FileType python
  \ syntax match Comment "\#[a-zA-Z0-9_-]\+"hs=s+0,he=e+0
  \ containedin=pythonString contained

":2 Highlight: `:Regular-word`
autocmd vimrc FileType python
  \ syntax match Comment "\:[a-zA-Z0-9_-]\+"hs=s+0,he=e-0
  \ containedin=pythonString contained

":2 Highlight: `{Regular-word}`
autocmd vimrc FileType python
  \ syntax match Type "{[a-zA-Z0-9_-]\+}"hs=s+0,he=e-0
  \ containedin=pythonString contained

":2 Highlight: `<Regular-word>`
autocmd vimrc FileType python
  \ syntax match Type "<[a-zA-Z0-9_-]\+>"hs=s+0,he=e-0
  \ containedin=pythonString contained
" endfold2

":1 FileType: Make (Makefile)
function! g:MakefileFoldExpr()
  ":2 ...
  " Case: start with 'COMMAND:'
  if getline(v:lnum) =~? '^[a-z0-9-_]\+:$'
    return '>1'
  endif

  if getline(v:lnum) =~? '^# endfold$'
    return '<1'
  endif

  return '='
  " endfold2
endfunction

" use tab. tabsize = 2
autocmd vimrc FileType make
  \   setlocal tabstop=2
  \ | setlocal shiftwidth=2
  \ | setlocal noexpandtab

autocmd vimrc FileType make
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:MakefileFoldExpr()
  \ | setlocal foldtext=getline(v:foldstart)[:-2]

autocmd vimrc FileType make
  \ nmap <buffer> <F5> :w<CR>:!make<CR>

":1 FileType: Yaml
function! g:YamlFoldText()
  ":2 ...
  let l:line = getline(v:foldstart)

  " First level label
  if l:line =~? '^[a-z0-9-_]\+:'
    return l:line
  endif

  if l:line[:2] ==# '  # -'
    return '  ▸ ' . l:line[4:]
  endif

  return '▸  ' . l:line[3:]
  " endfold2
endfunction

function! g:YamlFoldExpr()
  ":2 ...
  if getline(v:lnum) =~? '^# endfold$'
    return '<1'
  endif

  " First level label
  if getline(v:lnum) =~? '^[a-z0-9-_]\+:'
    return '>1'
  endif

  if getline(v:lnum) =~? '#:'
    return '>1'
  endif

  if getline(v:lnum) =~? '^  # -'
    return '>2'
  endif

  return '='
  " endfold2
endfunction

autocmd vimrc FileType yaml
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:YamlFoldExpr()
  \ | setlocal foldtext=g:YamlFoldText()

autocmd vimrc FileType yaml
  \ setlocal foldmarker=#\:,endfold

":1 FileType: Shell (sh, zsh)
function! g:ShellFoldText()
  ":2 ...
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
  return l:prefix . '▸   ' . l:trimmed
  " endfold2
endfunction

autocmd vimrc FileType sh
  \ nmap <F5> :w<CR>:!bash "%"<CR>

autocmd vimrc FileType sh
  \   setlocal foldmethod=marker
  \ | setlocal foldmarker=#:,#\ endfold
  \ | setlocal foldtext=g:ShellFoldText()

autocmd vimrc FileType zsh
  \   setlocal foldmethod=marker
  \ | setlocal foldmarker=#:,#\ endfold
  \ | setlocal foldtext=g:ShellFoldText()
" endfold

" Web development
":1 FileType: Javascript
function! g:JavascriptFoldExpr()
  ":2 ...
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
  ":3 +3 | `//:3 `
  if l:trimmed =~? '^//:3 '
    return '>3'
  endif

  ":3 -3 | `// endfold3`
  if l:trimmed =~? '^// endfold3'
    return '<3'
  endif
  " endfold

  return '='
  " endfold2
endfunction

function! g:JavascriptFoldText()
  ":2 ...
  let l:line = getline(v:foldstart)
  let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:leading_spaces = stridx(l:line, l:trimmed)
  let l:prefix = repeat(' ', l:leading_spaces)
  let l:size = strlen(l:trimmed)

  let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
  return l:prefix . '▸   ' . l:trimmed
  " endfold2
endfunction

autocmd vimrc FileType javascript
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:JavascriptFoldExpr()
  \ | setlocal foldtext=g:JavascriptFoldText()

autocmd vimrc FileType javascript
  \ nmap <buffer> <F5> :w<CR>:!time node '%'<CR>

" Highlight: `[selector]`
" Highlight: `[selector=attribute]`
autocmd vimrc FileType javascript
  \ syntax match Constant "\[[a-zA-Z0-9_\=-]\+\]"hs=s+0,he=e-0
  \ containedin=JsString contained

" Highlight: `[selector="attributte"]`
autocmd vimrc FileType javascript
  \ syntax match Constant "\[[a-zA-Z0-9_-]\+=\"[a-zA-Z0-9_\ -]\+\"\]"hs=s+0,he=e-0
  \ containedin=JsString contained

":1 FileType: Requirements
Plugin 'raimon49/requirements.txt.vim'
" endfold

" Vim (to sharpen the saw)
":1 FileType: Snippet
function! g:SnippetsFoldExpr()
  if getline(v:lnum) =~? '^snippet '
    return '>1'
  endif

  if getline(v:lnum) =~? '^# endfold$'
    return '<1'
  endif

  return '='
endfunction

" use tab. tabsize = 2
autocmd vimrc FileType snippets
  \   setlocal tabstop=2
  \ | setlocal shiftwidth=2
  \ | setlocal noexpandtab

autocmd vimrc FileType snippets
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:SnippetsFoldExpr()
  \ | setlocal foldtext=getline(v:foldstart)

":1 FileType: Vim (VimScript)
Plugin 'vim-jp/syntax-vim-ex'

let g:vimsyntax_noerror = 1
let g:vim_indent_cont = &shiftwidth

function! g:VimFoldText()
  ":2 ...
  let l:line = getline(v:foldstart)

  " for standard {{{ marker
  if l:line =~# ' {{' . '{$'
    " remove first character
    let l:line = strpart(l:line, 1)

    " remove leading fold mark
    let l:line = substitute(l:line, ' {{' . '{1', '', '')
    let l:line = substitute(l:line, ' {{' . '{2', '', '')
    let l:line = substitute(l:line, ' {{' . '{',  '', '')

    return '▸' . l:line
  else
    " next: refactor below lines
    let l:line = getline(v:foldstart)
    let l:trimmed = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
    let l:leading_spaces = stridx(l:line, l:trimmed)
    let l:prefix = repeat(' ', l:leading_spaces)
    let l:size = strlen(l:trimmed)

    let l:trimmed = strpart(l:trimmed, 4, l:size - 4)
    return l:prefix . '▸   ' . l:trimmed
  endif
  " endfold2
endfunction

autocmd vimrc FileType vim
  \   setlocal foldmethod=marker
  \ | setlocal foldmarker=\"\:,\"\ endfold
  \ | setlocal foldtext=g:VimFoldText()

" Highlight: escaped characters
autocmd vimrc FileType vim
  \ syntax match Comment '\\.'
  \ containedin=vimString contained
" endfold

" Other
":1 FileType: Ruby
Plugin 'vim-ruby/vim-ruby'

" Improve rendering speed
let g:ruby_no_expensive = 1

autocmd vimrc FileType ruby
  \ nmap <buffer> <F5>   :w<CR>:!time ruby '%'<CR>

autocmd vimrc FileType ruby
  \ nmap <buffer> <S-F5> :w<CR>:!time ruby '%' < input.txt<CR>
