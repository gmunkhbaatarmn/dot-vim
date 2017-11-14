set encoding=utf-8
scriptencoding utf-8

":1 Vundle setup
set runtimepath+=~/.vim/bundle/Vundle.vim

call call('vundle#rc', [])
let g:vundle_default_git_proto = 'git'

Plugin 'VundleVim/Vundle.vim'

":1 Plugin - Snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

":1 Plugin - NERDTree
" Not forward compatible. Reverted to 'da3874c'
Plugin 'scrooloose/nerdtree'

" Fast toggle
map <F2> :NERDTreeToggle<CR>

" Common
let g:NERDTreeMapOpenVSplit = 'a'
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMouseMode = 3
let g:NERDTreeWinPos = 'right'
let g:NERDTreeBookmarksFile = $HOME . '/.vim/.nerdtree-bookmarks'
function! g:NERDTreeCustomIgnoreFilter(path)
  if b:NERDTreeShowHidden ==# 1
    return 0
  endif

  let l:pathlist = [
        \ $HOME . '/Desktop',
        \ $HOME . '/Documents',
        \ $HOME . '/Downloads',
        \ $HOME . '/Dropbox',
        \ $HOME . '/Library',
        \ $HOME . '/Movies',
        \ $HOME . '/Music',
        \ $HOME . '/Pictures',
        \ $HOME . '/Videos',
        \]

  let l:patterns = [
        \ '\.min\.js$',
        \ '\.min\.css$',
        \]

  for l:p in l:pathlist
    if a:path.pathSegments == split(l:p, '/')
      return 1
    endif
  endfor

  for l:p in l:patterns
    if a:path.getLastPathComponent(0) =~# l:p
      return 1
    endif
  endfor
endfunction

":1 Plugin - ALE (Asynchronous Lint Engine)
Plugin 'w0rp/ale'

let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_set_signs = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_python_flake8_args = '--select F'


":1 Plugins

" Colorscheme
Plugin 'nanotech/jellybeans.vim'

let g:jellybeans_overrides = {
      \'Folded':     {                    'guibg': '151515' },
      \'FoldColumn': { 'guifg': '151515', 'guibg': '151515' },
      \}

" Features
Plugin 'ap/vim-css-color'
Plugin 'godlygeek/tabular'
Plugin 'tomtom/tcomment_vim'

" Filetype supports
Plugin 'tpope/vim-cucumber'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-markdown.git'
Plugin 'vim-ruby/vim-ruby'
Plugin 'pangloss/vim-javascript'
Plugin 'wavded/vim-stylus'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'mitsuhiko/vim-jinja'
" endfold

":1 Standard (frozen) configurations
syntax on                              " Enable syntax processing
filetype on                            " Enable file type detection
filetype plugin on                     " Enable plugins
filetype indent on                     " Enable indent

set autoindent                         " Enable auto indent
set nobackup nowritebackup noswapfile  " Disable backup

set hlsearch                           " Highlight search result
set nobomb                             " Unicode without BOM (Byte Order Mark)
set fileformats=unix fileformat=unix   " Preferred filetype
set hidden                             " Undo history save when changing buffers
set wildmenu                           " Show autocomplete menus
set splitbelow                         " New (split) window opens on bottom
set splitright                         " New (split) window opens on right
set autoread                           " Auto update if changed outside of Vim
set noerrorbells novisualbell          " No sound on errors
set ruler laststatus=0                 " Use ruler instead of status line
set backspace=indent,eol,start         " Allow backspace in insert mode
set lazyredraw                         " Redraw only when we need to.

":1 Configurations may change
set numberwidth=5                      " Line number width
set shellslash                         " Always use unix style slash /
set nojoinspaces                       " no insert two spaces in line join
set gdefault                           " Add the g flag to search/replace by default

" Easy fold toggle
nmap <Space> za
nmap e za

augroup vimrc
  autocmd!
augroup END

" Easy fold toggle for enter key. (Exclude `quickfix` filetype)
autocmd vimrc BufEnter * if &filetype == 'qf' |unmap <CR>|    endif
autocmd vimrc BufEnter * if &filetype != 'qf' | nmap <CR> za| endif
" endfold

":1 Aesthetic customizations
" colorscheme wombat256
colorscheme jellybeans
set termguicolors

" Contrast reduce for brackets
autocmd vimrc BufEnter * syn match Braces display '[{}()\[\]]'
autocmd vimrc BufEnter * hi def link Braces comment

" Ruler format
set rulerformat=%50(%=%f\ %y%m%r%w\ %l,%c%V\ %P%)

" Tab Configuration
set tabstop=2      " Number of visual spaces per TAB
set shiftwidth=2   " Number of spaces to use in (auto)indent
set softtabstop=2  " Number of spaces in tab when editing
set noexpandtab    " Use tab character instead of spaces

" Define list characters
set listchars=tab:▸\ ,eol:¬,trail:~,extends:>,precedes:<

" Define line break
set linebreak showbreak=…     " Wrap long line
set fillchars=vert:\|,fold:\  " Make foldtext more clean

" Recognize numbered list in text formatting
set formatoptions+=n

":1 Keyboard mapping

" Change the leader map
let g:mapleader = ','
let g:maplocalleader = ','

" Shortcut to toggle line number
set nonumber                             " Disable line numbers
set numberwidth=4                        " Line number width
set foldcolumn=4
nmap <leader>, :execute 'set number! foldcolumn=' . (!&foldcolumn * 4)<CR>

" Shortcut to fold method change
nmap <leader>f :set foldmethod=indent<CR>
nmap <leader>m :set foldmethod=marker<CR>

" Shortcut to rapidly toggle 'set list'
nmap <leader>l :set list!<CR>

" Shortcut to rapidly toggle 'set wrap'
nmap <leader>r :set wrap!<CR>

" Easy indent
nmap > >>
nmap < <<

" Easy ESC (compatible with LeaveInsert)
imap <C-c> <ESC>

" Window move
nmap <leader>d <C-w><LEFT>
nmap <leader>n <C-w><RIGHT>
nmap <leader>t <C-w><UP>
nmap <leader>h <C-w><DOWN>

" Window tab settings
nnoremap gk gt
nmap <C-t> :tabnew<CR>
map <M-1> 1gk
map <M-2> 2gk
map <M-3> 3gk
map <M-4> 4gk
map <M-5> 5gk
map <M-6> 6gk
map <M-7> 7gk
map <M-8> 8gk
map <M-9> 9gk

if system('uname') =~# 'Darwin'
  map <D-1> 1gk
  map <D-2> 2gk
  map <D-3> 3gk
  map <D-4> 4gk
  map <D-5> 5gk
  map <D-6> 6gk
  map <D-7> 7gk
  map <D-8> 8gk
  map <D-9> 9gk
endif

" Keymap switch
let g:current_keymap = ''
function! g:ToggleKeymap()
  if g:current_keymap ==# ''
    set keymap=mongolian-dvorak
    let g:current_keymap = 'mongolian-dvorak'
  else
    set keymap=""
    let g:current_keymap = ''
  endif
endfunction

imap <C-l> <ESC>:call ToggleKeymap()<CR>a
 map <C-l>      :call ToggleKeymap()<CR>
imap <F8>  <ESC>:call ToggleKeymap()<CR>a
 map <F8>       :call ToggleKeymap()<CR>

" Identify the syntax hightlighting group used at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Save file
" Need 'stty -ixon' command in shell (CLI).
" more: http://superuser.com/questions/227588/vim-command-line-imap-problem
autocmd vimrc BufEnter * nmap <C-s> :w!<CR>
autocmd vimrc BufEnter * imap <C-s> <ESC>:w!<CR>

" Close file
nmap <C-b> :close<CR>
imap <C-b> <ESC>:close<CR>
" endfold

":1 Automatic commands
" Change to the directory of the current file
autocmd vimrc BufEnter * silent! lcd %:p:h

" Remove trailing spaces
autocmd vimrc BufWritePre * :%s/\s\+$//e

" No bell sound in erratic action
autocmd vimrc BufEnter * set visualbell

":1 GUI only settings
if has('gui_running')
  set guifont=Monaco\ 10          " Change GUI font
  set guioptions-=T               " Remove toolbar
  set guioptions-=l               " Remove scroll
  set guioptions-=L               " Remove scroll in splitted window
  set guicursor+=n-c:hor10-Cursor " Change cursor shape to underscore
  set guicursor+=a:blinkon0       " Disable cursor blinking
endif

if system('uname') =~# 'Darwin'
  set guifont=Monaco:h13        " Change GUI font
  set clipboard=unnamed         " Use the OS clipboard by default
endif
" endfold

if filereadable($HOME . '/.vim/dvorak.vim')
  source $HOME/.vim/dvorak.vim
endif

if filereadable($HOME . '/.vim/filetypes.vim')
  source $HOME/.vim/filetypes.vim
endif

function! g:SourcePrint()
  colo macvim
  set background=light
  TOhtml
  w! ~/vim-source.html
  bdelete!
  !open ~/vim-source.html
  color wombat256
  set background=dark
endfunction

command! SourcePrint :call g:SourcePrint()
command! MarkdownPrint :!markdown-print %

" highlight over length lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
