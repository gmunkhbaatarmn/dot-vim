set encoding=utf-8
scriptencoding utf-8

" Enable vim defaults
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

":1 General
set hidden                              " Hide buffers when abandoned instead of unload
set visualbell                          " Use visual bell instead of beeping
set autoread                            " Auto update if changed outside of Vim
set nowritebackup noswapfile            " Disable backup

":1 Behavior
set splitbelow splitright               " Splits open bottom right

":1 Editor UI
set signcolumn=no                       " Disable sign column
set list                                " Show hidden characters
set listchars=tab:⋮\ ,nbsp:␣,trail:·    " Symbols for hidden characters
set showbreak=…                         " Add mark on wrapped long line
set fillchars=vert:\|,fold:\            " Make foldtext line more clean
set laststatus=0                        " Use ruler instead of status line
set foldcolumn=4                        " Same as line number width

":1 Tabs and Indents
set tabstop=2                           " The number of spaces a tab is
set shiftwidth=2                        " Number of spaces to use in auto(indent)
set softtabstop=-1                      " Automatically keeps in sync with shiftwidth

set autoindent                          " Use same indenting on new lines
set shiftround                          " Round indent to multiple of 'shiftwidth'
set expandtab                           " On pressing tab, insert spaces

":1 Text formatting
set formatoptions+=n                    " Recognize numbered list in text formatting
set nojoinspaces                        " No insert two spaces in line join (gq)

":1 Searching
set gdefault                            " Add the g flag to search/replace by default
set hlsearch                            " Highlight search result
" endfold

augroup vimrc
  autocmd!
augroup END

call plug#begin('~/.vim/plugged')

source $HOME/.vim/plugins.vim           " Plugins
source $HOME/.vim/filetypes.vim         " Languages
source $HOME/.vim/mappings.vim          " Keyboard mappings
source $HOME/.vim/shame.vim             " Quick and dirty solutions

if has('gui_running')
  source $HOME/.vim/only_gui.vim        " GUI only settings
else
  source $HOME/.vim/only_cli.vim        " Terminal only settings
endif

call plug#end()

if has('gui_running') && has('gui_macvim')
  colorscheme macvim2
else
  colorscheme jellybeans
endif
