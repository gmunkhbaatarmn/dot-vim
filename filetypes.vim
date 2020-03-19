scriptencoding utf-8

":1 Filetype: Vim (VimScript)
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

" Syntax: highlight escaped characters
autocmd vimrc FileType vim
  \ syntax match Comment "\\." containedin=vimString contained

":1 Filetype: Markdown
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
  let l:text = substitute(l:text, '#', ' ', 'g')

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
  \ | setlocal foldtext=g:MarkdownFoldText()
  \ | setlocal foldexpr=g:MarkdownFoldExpr()

" Syntax: `=>`
autocmd vimrc FileType markdown
  \ syntax match String  '=>'

" Syntax: `label:`
autocmd vimrc FileType markdown
  \ syntax match PreProc '[^ ]\+:'

":1 Filetype: Ruby
Plugin 'vim-ruby/vim-ruby'

" Improve rendering speed
let g:ruby_no_expensive = 1

autocmd vimrc BufEnter * if &filetype == 'ruby' |
  \ nmap <F5>   :w<CR>:!time ruby "%"             <CR>|endif

autocmd vimrc BufEnter * if &filetype == 'ruby' |
  \ nmap <S-F5> :w<CR>:!time ruby "%" < input.txt <CR>|endif
