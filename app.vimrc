":1 Vundle setup
set rtp+=~/.vim/bundle/vundle/
set rtp+=/Applications/MacVim.app/Contents/Resources/vim/runtime
call vundle#rc()

Bundle "gmarik/vundle"

":1 Plugin - Snipmate
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"

":1 Plugin - NERDTree
Bundle "scrooloose/nerdtree"

" Fast toggle
map <F2> :NERDTreeToggle<CR>

" Dvorak fix
let g:NERDTreeMapOpenInTab="<C-S-t>"
let g:NERDTreeMapOpenInTabSilent="<C-S-D>"
let g:NERDTreeMapOpenVSplit="a"
" let g:NERDTreeMinimalUI=1

" Common
let g:NERDTreeCaseSensitiveSort=1
let g:NERDTreeDirArrows=1
let g:NERDTreeIgnore=["\.pyc$"]
let g:NERDTreeMouseMode=3
let g:NERDTreeWinPos="right"

" Open a NERDTree automatically when vim starts up if no files were specified
" autocmd vimenter * if !argc() | NERDTree | endif

":1 Plugin - Syntastic
Bundle "scrooloose/syntastic"
let g:syntastic_check_on_open  = 0
let g:syntastic_enable_signs   = 1
let g:syntastic_auto_loc_list  = 1
let g:syntastic_python_checker = 'pyflakes'
let g:syntastic_error_symbol   = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_mode_map = { 'mode': 'active',
      \ 'active_filetypes': [''],
      \ 'passive_filetypes': ['htmldjango'] }
let b:shell="bash"

":1 Plugins
" Features
Bundle "godlygeek/tabular"
Bundle "tomtom/tcomment_vim"
Bundle "gmunkhbaatarmn/vim-checkdown"

Bundle "Lokaltog/vim-powerline"
Bundle "duwanis/tomdoc.vim"

" Filetype supports
Bundle "tpope/vim-cucumber"
Bundle "kchmck/vim-coffee-script"

Bundle "tpope/vim-markdown.git"
let g:markdown_folding = 1

Bundle "vim-ruby/vim-ruby"
Bundle "pangloss/vim-javascript"
Bundle "wavded/vim-stylus"
Bundle "hynek/vim-python-pep8-indent"
Bundle "mitsuhiko/vim-jinja"

" Bundle "gmunkhbaatarmn/vim-mongolian-dvorak"
" endfold


":1 Standard (frozen) configurations
syntax on                              " Enable syntax hightlight
filetype on                            " Enable file type detection
filetype plugin on                     " Enable plugins
filetype indent on                     " Enable indent

set nocompatible                       " Enable VIM features
set number                             " Enable line numbers
set autoindent                         " Enable auto indent
set nobackup nowritebackup noswapfile  " Disable backup

set hlsearch                           " Highlight search result
set encoding=utf-8                     " Unicode text encoding
set fileformats=unix                   " Default file types
set fileformat=unix                    " Default file type
set hidden                             " Undo history save when changing buffers
set wildmenu                           " Show autocomplete menus
set splitbelow                         " New (split) window opens on bottom
set splitright                         " New (split) window opens on right
set laststatus=2                       " Status line always show
set autoread                           " Auto update if changed outside of Vim
set noerrorbells novisualbell          " No sound on errors

":1 Configurations may change
set numberwidth=4                      " Line number width
set textwidth=80                       " Default text width
set shellslash                         " Always use unix style slash /
set nojoinspaces                       " no insert two spaces in line join
set t_Co=256                           " (CLI only) Number of colors
set t_vb=                              " (CLI only) Visual bell

" set foldignore-=#            " Fix fold-indent
" set backspace=2                " Backspace fix
" set clipboard+=unnamed         " Clipboard fix
" endfold


":1 Aestetic customizations
colorscheme wombat256

" Tab Configuration
set tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab

" Define list characters
set listchars=tab:▸\ ,eol:¬,trail:~,extends:>,precedes:<

" Define line break
set linebreak showbreak=…     " Wrap long line
set fillchars=vert:\|,fold:\  " Make foldtext more clean

set formatoptions+=n
let $LC_ALL = "en_US.UTF-8"
set clipboard=unnamed


":1 Keyboard mapping
" Change the leader map
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" Shortcut to fold method change
nmap <leader>f :set foldmethod=indent<CR>
nmap <leader>m :set foldmethod=marker<CR>

" Shortcut to rapidly toggle "set list"
nmap <leader>l :set list!<CR>

" Shortcut to rapidly toggle "set wrap"
nmap <leader>r :set wrap!<CR>

" Easy indent
nmap > >>
nmap < <<

" Window move
nmap <leader>d <C-w><LEFT>
nmap <leader>n <C-w><RIGHT>
nmap <leader>t <C-w><UP>
nmap <leader>h <C-w><DOWN>

" Tab next, prev, new
nmap eh :tabnext<CR>
nmap et :tabprev<CR>
nmap en :tabnew<CR>

" Buffer next, prev
nmap .t :bn<CR>
nmap .h :bp<CR>

" Keymap switch
let g:current_keymap=""
function! ToggleKeymap()
  if (g:current_keymap=="")
    set keymap=mongolian-dvorak
    let g:current_keymap="mongolian-dvorak"
  else
    set keymap=""
    let g:current_keymap=""
  endif
endfunction

imap <C-l> <ESC>:call ToggleKeymap()<CR>a
map <C-l> :call ToggleKeymap()<CR>
imap <F8> <ESC>:call ToggleKeymap()<CR>a
map <F8> :call ToggleKeymap()<CR>

" Save file
" Need "stty -ixon" command in shell.
" more: http://superuser.com/questions/227588/vim-command-line-imap-problem
nmap <C-s> :w!<CR>
imap <C-s> <ESC>:w!<CR>

" Close file
nmap <C-b> :close<CR>
imap <C-b> <ESC>:close<CR>
" endfold

":1 Automatic commands
" change to the directory of the current file
autocmd BufEnter * silent! lcd %:p:h

" Remove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

autocmd BufEnter * set visualbell t_vb=


":1 GUI only settings
if has("gui_running")
  set guifont=Monaco:h12        " Change GUI font
  set guioptions-=T           " Remove toolbar
  " set cursorline              " Highlight cursorline

  " Remove scroll
  set guioptions-=l
  set guioptions-=L
  " set guioptions-=r
  " set guioptions-=b
  colorscheme underwater
endif

":1 Some extension
so $HOME/.vim/dvorak.vimrc
so $HOME/.vim/filetype.vimrc
