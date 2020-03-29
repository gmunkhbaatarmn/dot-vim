set encoding=utf-8
scriptencoding utf-8

":1 Init
" Enables 24-bit RGB color in the terminal
if has('termguicolors') && $COLORTERM =~# 'truecolor\|24bit'
	set termguicolors
endif

":1 General
set hidden                              " Hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac            " Use Unix as the standard file type
set synmaxcol=2500                      " Don't syntax highlight long lines

" Behavior
set nowrap                              " No wrap by default
set splitbelow splitright               " Splits open bottom right
set backspace=indent,eol,start          " Intuitive backspacing in insert mode

" Editor UI
set nonumber                            " Don't show line numbers

" Tabs and Indents
set tabstop=2                           " The number of spaces a tab is
set shiftwidth=2                        " Number of spaces to use in auto(indent)
set softtabstop=-1                      " Automatically keeps in sync with shiftwidth
set autoindent                          " Use same indenting on new lines
set shiftround                          " Round indent to multiple of 'shiftwidth'
" endfold

augroup vimrc
  autocmd!
augroup END

" Vundle: begin
filetype off
set runtimepath+=$HOME/.vim/bundle/Vundle.vim
call call('vundle#rc', [])

source $HOME/.vim/plugins.vim           " Plugins
source $HOME/.vim/filetypes.vim         " Languages
source $HOME/.vim/mappings.vim          " Keyboard mappings
source $HOME/.vim/shame.vim             " Quick and dirty solutions

" Vundle: end
call vundle#end()
filetype plugin indent on
