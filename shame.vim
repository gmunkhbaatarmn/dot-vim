scriptencoding utf-8

" This file is for:
" 1. not decided where to put the code
" 2. ugly codes that need refactor

":1 Only on: Mac OS
if system('uname') =~# 'Darwin'
  set clipboard=unnamed,unnamedplus     " Use the OS clipboard by default
endif

":1 Only on: MacVim
if has('gui_running') && has('gui_macvim')
  set macligatures
  set guifont=FiraCodeNerdFontComplete-Regular:h15
  set guioptions-=L                     " Remove scroll in splitted window
  set guicursor+=n-c:hor10-Cursor       " Change cursor shape to underscore
  set guicursor+=a:blinkon0             " Disable cursor blinking
  set visualbell                        " Disable error sound

  " Window tab settings
  map <D-1> 1gt
  map <D-2> 2gt
  map <D-3> 3gt
  map <D-4> 4gt
  map <D-5> 5gt
  map <D-6> 6gt
  map <D-7> 7gt
  map <D-8> 8gt
  map <D-9> 9gt
endif
" endfold

set gdefault                            " Add the g flag to search/replace by default
set signcolumn=no
set nojoinspaces                        " No insert two spaces in line join (gq)
set autoread                            " Auto update if changed outside of Vim
set nobackup nowritebackup noswapfile   " Disable backup
set wildmenu                            " Show autocomplete menus
set t_vb=                               " No beep or flash on terminal
set ruler laststatus=0                  " Use ruler instead of status line
set rulerformat=%50(%=%f\ %y%m%r%w\ %l,%c%V\ %P%)
set listchars=tab:⋮\ ,nbsp:␣,trail:·    " Symbols for hidden characters
set linebreak                           " Define line break
set showbreak=…                         " Add mark on wrapped long line
set fillchars=vert:\|,fold:\            " Make foldtext line more clean
set formatoptions+=n                    " Recognize numbered list in text formatting
set numberwidth=4                       " Line number width
set foldcolumn=4                        " Same as line number width

Plug 'thinca/vim-localrc'
Plug 'kchmck/vim-coffee-script'  " todo: remove vim-coffee-script
Plug 'chr4/nginx.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

Plug 'lambdalisue/suda.vim'
command SudoSave :w suda://%

Plug 'dstein64/vim-startuptime'
" command :Startuptime

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

":1 FileType: Coffeescript
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

":1 FileType: Java
autocmd vimrc FileType java setlocal foldmethod=marker foldmarker=BEGIN\ CUT\ HERE,END\ CUT\ HERE

autocmd vimrc BufEnter * if &filetype == 'java' |nmap <F5>   :w<CR>:!javac "%"; java "%:t:r";             rm -f "%:r.class" "%:rHarness.class"<CR>| endif
autocmd vimrc BufEnter * if &filetype == 'java' |nmap <S-F5> :w<CR>:!javac "%"; java "%:t:r" < input.txt; rm -f "%:r.class" "%:rHarness.class"<CR>| endif

":1 FileType: PHP
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

":1 FileType: CSS
Plug 'hail2u/vim-css3-syntax'

autocmd vimrc FileType css setlocal foldmethod=marker foldmarker=\/*:,\/*\ endfold\ *\/

":1 FileType: Sass
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

":1 FileType: Help
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
autocmd vimrc FileType php
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

" Fix for column edit
imap <C-c> <ESC>

" Identify the syntax hightlighting group used at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

":1 SourcePrint
function! g:SourcePrint()
  set background=light
  TOhtml
  w! ~/vim-source.html
  bdelete!
  !open ~/vim-source.html
  set background=dark
endfunction

command! SourcePrint :call g:SourcePrint()
