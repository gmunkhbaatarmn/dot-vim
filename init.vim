set encoding=utf-8
scriptencoding utf-8

augroup vimrc
  autocmd!
augroup END

" Tab Configuration
set tabstop=2                          " Number of visual spaces per TAB
set shiftwidth=2                       " Number of spaces to use in (auto)indent
set softtabstop=2                      " Number of spaces in tab when editing
set expandtab                          " Use spaces instead of tab

":1 Standard configurations
syntax enable
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
set visualbell t_vb=                   " No beep or flash on terminal
set ruler laststatus=0                 " Use ruler instead of status line
set backspace=indent,eol,start         " Allow backspace in insert mode
set lazyredraw                         " Redraw only when we need to

set termguicolors                      " Display more colors on terminal
set shellslash                         " Always use unix style slash /
set gdefault                           " Add the g flag to search/replace by default
set nojoinspaces                       " No insert two spaces in line join (gq)
set tags=.git/tags;./tags;tags         " Improve ctags support

":1 Aesthetic customizations
" Ruler format
set rulerformat=%50(%=%f\ %y%m%r%w\ %l,%c%V\ %P%)

set listchars=tab:▸\ ,eol:¬            " Character to show tab, end of line
set listchars+=trail:~                 " Character to show trailing spaces
set linebreak                          " Define line break
set showbreak=…                        " Add mark on wrapped long line
set fillchars=vert:\|,fold:\           " Make foldtext line more clean
set formatoptions+=n                   " Recognize numbered list in text formatting
set nonumber                           " Disable line numbers
set numberwidth=4                      " Line number width
set foldcolumn=4                       " Same as line number width
" endfold

" Enable plugins feature
filetype off
set runtimepath+=$HOME/.vim/bundle/Vundle.vim
call call('vundle#rc', [])

source $HOME/.vim/plugins.vim          " Plugins
source $HOME/.vim/filetypes.vim        " Languages

":1 Only on: Mac OS
if system('uname') =~# 'Darwin'
  set clipboard=unnamed,unnamedplus    " Use the OS clipboard by default
endif

":1 Only on: MacVim
if has('gui_running') && has('gui_macvim')
  set macligatures
  set guifont=Fira\ Code:h15      " Change GUI font
  set guioptions-=L               " Remove scroll in splitted window
  set guicursor+=n-c:hor10-Cursor " Change cursor shape to underscore
  set guicursor+=a:blinkon0       " Disable cursor blinking
  set visualbell                  " Disable error sound

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

":1 Plugins: Filetype supports
Plugin 'kchmck/vim-coffee-script'  " todo: remove vim-coffee-script
Plugin 'pangloss/vim-javascript'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'mitsuhiko/vim-jinja'
" endfold

source $HOME/.vim/mappings.vim         " Keyboard mappings
source $HOME/.vim/shame.vim            " Quick and dirty solutions

call vundle#end()                      " Required by Vundle
filetype plugin indent on              " Required by Vundle
