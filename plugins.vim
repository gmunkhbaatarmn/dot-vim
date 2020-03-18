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

":1 Plugin: NERDTree syntax hightlight
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'

let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightColor = {
      \'.*_TESTS$': '3AFFDB',
      \}

":1 Plugin: CtrlP
Plugin 'ctrlpvim/ctrlp.vim'
" endfold

" Interface
":1 Plugin: Jellybeans
Plugin 'nanotech/jellybeans.vim'

let g:jellybeans_overrides = {
      \'Folded':     { 'guifg': '8fbfdc', 'guibg': '151515' },
      \'FoldColumn': { 'guifg': '151515', 'guibg': '151515' },
      \}

colorscheme jellybeans
" endfold
