set encoding=utf-8
scriptencoding utf-8

" Enable plugins feature
set runtimepath+=$HOME/.vim/bundle/Vundle.vim
call call('vundle#rc', [])

source $HOME/.vim/plugins.vim      " Plugins

":1 Only on: Mac OS
if system('uname') =~# 'Darwin'
  set clipboard=unnamed,unnamedplus    " Fix Mac OS clipboard issue
endif
" endfold

":1 Plugin: Markdown
Plugin 'plasticboy/vim-markdown'

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

":1 Plugins
" Features
Plugin 'tomtom/tcomment_vim'

" Filetype supports
Plugin 'kchmck/vim-coffee-script'  " todo: remove vim-coffee-script
Plugin 'vim-ruby/vim-ruby'
Plugin 'pangloss/vim-javascript'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'mitsuhiko/vim-jinja'
" endfold

":1 Standard configurations
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
set lazyredraw                         " Redraw only when we need to

set termguicolors                      " Display more colors on terminal
set shellslash                         " Always use unix style slash /
set gdefault                           " Add the g flag to search/replace by default
set nojoinspaces                       " No insert two spaces in line join (gq)
set tags=.git/tags;./tags;tags         " Improve ctags support

augroup vimrc
  autocmd!
augroup END

":1 Aesthetic customizations
" Ruler format
set rulerformat=%50(%=%f\ %y%m%r%w\ %l,%c%V\ %P%)

" Tab Configuration
set tabstop=2                          " Number of visual spaces per TAB
set shiftwidth=2                       " Number of spaces to use in (auto)indent
set softtabstop=2                      " Number of spaces in tab when editing
set expandtab                          " Use spaces instead of tab

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

source $HOME/.vim/gui_running.vim      " GUI only settings
source $HOME/.vim/mappings.vim         " Keyboard mappings
source $HOME/.vim/ftplugins.vim        " Filetype configs
source $HOME/.vim/shame.vim            " Quick and dirty solutions
