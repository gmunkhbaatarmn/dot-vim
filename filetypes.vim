scriptencoding utf-8

" For each FileType:
"
"   - General
"   - Fold
"   - Mapping
"   - Syntax

" General purpose usage
":1 FileType: Markdown
Plugin 'plasticboy/vim-markdown'
Plugin 'rhysd/vim-gfm-syntax'

":2 todo: review below lines
" let g:vim_markdown_frontmatter = 1
" let g:vim_markdown_strikethrough = 1
" let g:vim_markdown_folding_level = 6
" let g:vim_markdown_override_foldtext = 1
" let g:vim_markdown_folding_style_pythonic = 1
" let g:vim_markdown_conceal = 0
" let g:vim_markdown_conceal_code_blocks = 0
" let g:vim_markdown_edit_url_in = 'vsplit'
" let g:vim_markdown_auto_insert_bullets = 1
" let g:vim_markdown_new_list_item_indent = 0
" let g:vim_markdown_toc_autofit = 0
" let g:vim_markdown_fenced_languages = [
"   \ 'c++=cpp',
"   \ 'viml=vim',
"   \ 'bash=sh',
"   \ 'ini=dosini',
"   \ 'js=javascript',
"   \ 'json=javascript',
"   \ 'jsx=javascriptreact',
"   \ 'tsx=typescriptreact',
"   \ 'docker=Dockerfile',
"   \ 'makefile=make',
"   \ 'py=python'
"   \ ]
" let g:gfm_syntax_enable_always = 0
" let g:gfm_syntax_highlight_emoji = 0
" let g:gfm_syntax_enable_filetypes = ['markdown']
" endfold2

let g:vim_markdown_folding_disabled = 1   " Disable header fold
let g:vim_markdown_override_foldtext = 0  " Disable plugin's fold text
let g:vim_markdown_frontmatter = 1        " Enable YAML header

" autocmd vimrc FileType markdown
"   \   setlocal conceallevel=0
  " todo: \ | setlocal autoindent
  " todo: \ | setlocal formatoptions=tcroqn2
  " todo: \ | setlocal comments=n:>

function! g:MarkdownFoldText()
  ":2 ...
  let l:text = getline(v:foldstart)
  if l:text ==# '---'
    let l:text = getline(v:foldstart + 1)
  endif

  let l:text = '▸' . l:text[1:]
  " let l:text = substitute(l:text, '#', ' ', 'g')

  return l:text
  " endfold2
endfunction

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

autocmd vimrc FileType markdown
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:MarkdownFoldExpr()
  \ | setlocal foldtext=g:MarkdownFoldText()

" Highlight: `=>`
autocmd vimrc FileType markdown
  \ syntax match String  '=>'

" Highlight: `label:`
autocmd vimrc FileType markdown
  \ syntax match PreProc '[^ ]\+:'
" endfold

" Project development
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
