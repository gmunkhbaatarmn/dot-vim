set encoding=utf-8
scriptencoding utf-8

":1 Vundle setup
set runtimepath+=$HOME/.vim/bundle/Vundle.vim

call call('vundle#rc', [])
let g:vundle_default_git_proto = 'git'

Plugin 'VundleVim/Vundle.vim'

":1 Plugin: Snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

":1 Plugin: NERDTree
Plugin 'scrooloose/nerdtree'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'

" let g:NERDTreeFileExtensionHighlightFullName = 1
" let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
" let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_TESTS$'] = '3AFFDB'

" Fast toggle
map <F2> :NERDTreeToggle<CR>

let g:NERDTreeMapOpenVSplit = 'a'
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMouseMode = 3
let g:NERDTreeWinPos = 'right'
let g:NERDTreeBookmarksFile = $HOME . '/.vim/.nerdtree-bookmarks'

":1 Plugin: ALE (Asynchronous Lint Engine)
Plugin 'w0rp/ale'

let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_set_signs = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_python_flake8_executable = 'python3'   " or 'python' for Python 2
let g:ale_python_flake8_options = '-m flake8 --select F --ignore E402,E501'
let g:ale_sass_stylelint_executable = 'sasslint'
let g:ale_linters = {
\   'php': ['php', 'phpcs'],
\}
let g:ale_php_phpcs_standard = 'psr1,psr2,psr12'

highlight link ALEErrorLine error
highlight link ALEWarningLine warning

":1 Plugin: Jellybeans
Plugin 'nanotech/jellybeans.vim'

let g:jellybeans_overrides = {
      \'Folded':     { 'guifg': '8fbfdc', 'guibg': '151515' },
      \'FoldColumn': { 'guifg': '151515', 'guibg': '151515' },
      \}

":1 Plugin: Markdown
Plugin 'plasticboy/vim-markdown'

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

":1 Plugins
" Features
Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

Plugin 'ap/vim-css-color'
Plugin 'godlygeek/tabular'
Plugin 'tomtom/tcomment_vim'
Plugin 'junegunn/goyo.vim'

" Filetype supports
Plugin 'kchmck/vim-coffee-script'  " todo: remove vim-coffee-script
Plugin 'vim-ruby/vim-ruby'
Plugin 'pangloss/vim-javascript'
Plugin 'hail2u/vim-css3-syntax'
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
set tags=.git/tags;./tags;tags

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
colorscheme jellybeans
set termguicolors

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

set nonumber                             " Disable line numbers
set numberwidth=4                        " Line number width
set foldcolumn=4
" endfold

" highlight over length lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929

" Identify the syntax hightlighting group used at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" endfold

":1 Automatic commands
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

if has('gui_running') && system('uname') =~# 'Darwin'
  set macligatures
  set guifont=Fira\ Code:h15        " Change GUI font
endif

if system('uname') =~# 'Darwin'
  set clipboard=unnamed         " Use the OS clipboard by default
endif
" endfold

if filereadable($HOME . '/.vim/mappings.vim')
  source $HOME/.vim/mappings.vim   " Keyboard mappings
endif

if filereadable($HOME . '/.vim/dvorak.vim')
  source $HOME/.vim/dvorak.vim     " Dvorak specific mappings
endif

if filereadable($HOME . '/.vim/filetypes.vim')
  source $HOME/.vim/filetypes.vim
endif

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

":1 :MarkdownPrint
command! MarkdownPrint :!markdown-print %

":1 :ProseMode
function! ProseMode()
  call goyo#execute(0, [])
  set nocopyindent
  set nosmartindent noai nolist noshowmode noshowcmd
  set complete+=s
endfunction

command! ProseMode call ProseMode()
