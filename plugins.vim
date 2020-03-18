" Startup
":1 Plugin: Vundle
Plugin 'VundleVim/Vundle.vim'
let g:vundle_default_git_proto = 'git'

":1 Plugin: localrc
Plugin 'thinca/vim-localrc'
" endfold

" Commands
":1 Plugin: NERDTree
Plugin 'preservim/nerdtree'

" Fast toggle
map <F2> :NERDTreeToggle<CR>

let g:NERDTreeMapOpenVSplit = 'a'
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMouseMode = 3            " Single click always
let g:NERDTreeWinPos = 'right'
let g:NERDTreeBookmarksFile = $HOME . '/.vim/.nerdtree-bookmarks'
