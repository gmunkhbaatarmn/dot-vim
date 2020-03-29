scriptencoding utf-8

" This file is for:
" 1. not decided where to put the code
" 2. ugly codes that need refactor

Plugin 'chrisbra/csv.vim'
Plugin 'MTDL9/vim-log-highlighting'
Plugin 'chr4/nginx.vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'tpope/vim-git'

Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/gv.vim'

Plugin 'lambdalisue/suda.vim'
command SudoSave :w suda://%

Plugin 'dstein64/vim-startuptime'
" command :Startuptime

":1 Lua
" Plugin 'tbastos/vim-lua'
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

":1 Java
autocmd vimrc FileType java setlocal foldmethod=marker foldmarker=BEGIN\ CUT\ HERE,END\ CUT\ HERE

autocmd vimrc BufEnter * if &filetype == 'java' |nmap <F5>   :w<CR>:!javac "%"; java "%:t:r";             rm -f "%:r.class" "%:rHarness.class"<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'java' |nmap <S-F5> :w<CR>:!javac "%"; java "%:t:r" < input.txt; rm -f "%:r.class" "%:rHarness.class"<CR>| endif
" endfold

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

nmap <C-d> :call MarkdownToggle()<CR>
vmap <C-d> :call MarkdownToggle()<CR>

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

" let g:htmljinja_disable_html_upgrade = 0

autocmd vimrc BufEnter *.html setlocal filetype=htmljinja
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
autocmd vimrc FileType java
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab

" no tab use. tab = 4 space
autocmd vimrc FileType php,cs
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
" endfold

":1 Dvorak: Move down  (use "h" instead of "j")
map h g<down>
map H 6g<down>

" accelerate on normal mode
nmap h <Plug>(accelerated_jk_gj)
nmap H 6<Plug>(accelerated_jk_gj)

" todo: <C-h>
" todo: handle replaced command: "h" (no mapping)
" no action needed for no mapping

" todo: handle replaced command: "H" (no mapping)
" no action needed for no mapping

" todo: handle replaced key: "j" (move up)
" noremap j d

" todo: handle replaced key: "J" (join lines, minimum of two lines)
" noremap J D

":1 Dvorak: Move up    (use "t" instead of "k")
map t g<up>
map T 6g<up>

" accelerate on normal mode
nmap t <Plug>(accelerated_jk_gk)
nmap T 6<Plug>(accelerated_jk_gk)

" todo: <C-t>
" todo: help page <t>

" todo: handle replaced command: "t" (...)
" todo: handle replaced command: "T" (...)

" todo: handle replaced key: "k"
noremap k <nop>

" todo: handle replaced key: "K"
noremap K <nop>

":1 Dvorak: Move left  (use "d" instead of "h")
map d <left>

" todo: handle replaced command: "d" (...)
noremap j d

" todo: handle replaced command: "D" (...)
" todo: handle replaced key: "h"
" todo: handle replaced key: "H"

":1 Dvorak: Move right (use "n" instead of "l")
map n <right>

" todo: handle replaced command: "n" (...)
" todo: handle replaced command: "N" (...)
" todo: handle replaced key: "l"
" todo: handle replaced key: "l"
" endfold

":1 Dvorak: Mappings
" Goto line beginning
noremap _ ^

" Goto line end
noremap - $

" To command line mode
noremap s :
noremap S :

" Search next (was: move to right character)
noremap l n

" Search prev (was: move to up line)
noremap L N

":1 Dvorak: NERDTree
let g:NERDTreeMapOpenInTab = '<C-S-t>'
let g:NERDTreeMapOpenInTabSilent='<C-S-D>'
" endfold

" Identify the syntax hightlighting group used at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Highlight over length lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929

":1 :SourcePrint
function! g:SourcePrint()
  colo macvim
  set background=light
  TOhtml
  w! ~/vim-source.html
  bdelete!
  !open ~/vim-source.html
  color jellybeans
  set background=dark
endfunction

command! SourcePrint :call g:SourcePrint()

":1 :ProseMode
function! ProseMode()
  call goyo#execute(0, [])
  set nocopyindent
  set nosmartindent noai nolist noshowmode noshowcmd
  set complete+=s
endfunction

command! ProseMode call ProseMode()
