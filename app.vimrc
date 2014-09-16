":1 Vundle setup
set rtp+=~/.vim/bundle/vundle/
set rtp+=/Applications/MacVim.app/Contents/Resources/vim/runtime
call vundle#rc()

Bundle 'gmarik/vundle'

":1 Plugin - Snipmate
" todo: snipmate vs ultisnips?
" todo: maybe convert snipmate snippets
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'

":1 Plugin - Ultisnips

" Track the engine.
Plugin 'SirVer/ultisnips'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsSnippetsDir="~/.vim/ultisnippets"

":1 Plugin - NERDTree
Bundle 'scrooloose/nerdtree'

" Fast toggle
map <F2> :NERDTreeToggle<CR>

" Common
let g:NERDTreeMapOpenVSplit = 'a'
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMouseMode = 3
let g:NERDTreeWinPos = 'right'

function! NERDTreeCustomIgnoreFilter(path)
  if b:NERDTreeShowHidden ==# 0
    let patterns = [
          \ '\.min\.js$',
          \ '\.min\.css$',
          \ '\.eot$',
          \ '\.svg$',
          \ '\.ttf$',
          \ '\.woff$',
          \ '\.pyc$',
          \]

    let pathlist = [
          \ $HOME . '/Applications',
          \ $HOME . '/Library',
          \ $HOME . '/Downloads',
          \ $HOME . '/Dropbox',
          \ $HOME . '/Movies',
          \ $HOME . '/Videos',
          \ $HOME . '/Music',
          \ $HOME . '/Pictures',
          \ $HOME . '/Desktop',
          \ $HOME . '/Documents',
          \ $HOME . '/Public',
          \ $HOME . '/contestapplet.conf',
          \ $HOME . '/contestapplet.conf.bak',
          \ $HOME . '/Templates',
          \ $HOME . '/ISO',
          \ $HOME . '/VirtualBox VMs',
          \ $HOME . '/opt',
          \]

    for p in pathlist
      if a:path.pathSegments == split(p, "/")
        return 1
      endif
    endfor

    for p in patterns
      if a:path.getLastPathComponent(0) =~# p
        return 1
      endif
    endfor
  endif
endfunction

":1 Plugin - Syntastic
Bundle 'scrooloose/syntastic'
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
" todo: don't validate html
let g:syntastic_mode_map = {'passive_filetypes': ['html']}
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_auto_loc_list = 1

":1 Plugins
" Features
Bundle 'godlygeek/tabular'
Bundle 'tomtom/tcomment_vim'
Bundle 'gmunkhbaatarmn/vim-checkdown'
Bundle 'duwanis/tomdoc.vim'

" Filetype supports
Bundle 'tpope/vim-cucumber'
Bundle 'kchmck/vim-coffee-script'

Bundle 'tpope/vim-markdown.git'
let g:markdown_folding = 1

Bundle 'vim-ruby/vim-ruby'
Bundle 'pangloss/vim-javascript'
Bundle 'wavded/vim-stylus'
Bundle 'hynek/vim-python-pep8-indent'
" todo: html filetype always htmljinja
Bundle 'mitsuhiko/vim-jinja'
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
set encoding=utf-8                     " Preferred encoding
set fileformats=unix fileformat=unix   " Preferred filetype
set hidden                             " Undo history save when changing buffers
set wildmenu                           " Show autocomplete menus
set splitbelow                         " New (split) window opens on bottom
set splitright                         " New (split) window opens on right
set autoread                           " Auto update if changed outside of Vim
set noerrorbells novisualbell          " No sound on errors
set ruler laststatus=0                 " Use ruler instead of status line

":1 Configurations may change
set numberwidth=4                      " Line number width
set shellslash                         " Always use unix style slash /
set nojoinspaces                       " no insert two spaces in line join
set t_Co=256                           " (CLI only) Number of colors
set t_vb=                              " (CLI only) Visual bell

nmap <Space> za
nmap <CR> za
nmap e za
" endfold

":1 Aestetic customizations
colorscheme wombat256

" Contrast reduce for brackets
autocmd BufEnter * syn match Braces display '[{}()\[\]]'
autocmd BufEnter * hi def link Braces comment

" Ruler format
set rulerformat=%40(%=%f\ %y%m%r%w\ %l,%c%V\ %P%)

" Tab Configuration
set tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab

" Define list characters
set listchars=tab:▸\ ,eol:¬,trail:~,extends:>,precedes:<

" Define line break
set linebreak showbreak=…     " Wrap long line
set fillchars=vert:\|,fold:\  " Make foldtext more clean

" Recognize numbered list in text formatting
set formatoptions+=n

":1 Keyboard mapping
" Change the leader map
let mapleader = ','
let g:mapleader = ','
let maplocalleader = ','
let g:maplocalleader = ','

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

if system("uname") =~ 'Darwin'
  map <D-1> 1gk
  map <D-2> 2gk
  map <D-3> 3gk
  map <D-4> 4gk
endif

" Keymap switch
let g:current_keymap = ''
function! ToggleKeymap()
  if g:current_keymap == ''
    set keymap=mongolian-dvorak
    let g:current_keymap = 'mongolian-dvorak'
  else
    set keymap=""
    let g:current_keymap = ''
  endif
endfunction

imap <C-l> <ESC>:call ToggleKeymap()<CR>a
map <C-l> :call ToggleKeymap()<CR>
imap <F8> <ESC>:call ToggleKeymap()<CR>a
map <F8> :call ToggleKeymap()<CR>

" Identify the syntax hightlighting group used at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Save file
" Need 'stty -ixon' command in shell (CLI).
" more: http://superuser.com/questions/227588/vim-command-line-imap-problem
autocmd BufEnter * nmap <C-s> :w!<CR>
autocmd BufEnter * imap <C-s> <ESC>:w!<CR>

" Close file
nmap <C-b> :close<CR>
imap <C-b> <ESC>:close<CR>
" endfold

":1 Automatic commands
" Change to the directory of the current file
autocmd BufEnter * silent! lcd %:p:h

" Remove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

" No bell sound in erratic action
autocmd BufEnter * set visualbell t_vb=

":1 GUI only settings
if has('gui_running')
  set guifont=Monaco\ 10        " Change GUI font
  set guioptions-=T             " Remove toolbar
  set guioptions-=l             " Remove scroll
  set guioptions-=L             " Remove scroll in splitted window
  colorscheme underwater
endif

if system("uname") =~ 'Darwin'
  set guifont=Monaco:h14        " Change GUI font
  set clipboard=unnamed         " Copy to GUI clipboard
endif
" endfold

so $HOME/.vim/dvorak.vimrc
so $HOME/.vim/filetype.vimrc
so $HOME/.vim/writer.vimrc
