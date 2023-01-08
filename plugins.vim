" For each plugin:
"
"   - Command
"   - Mapping

" Commands
"1 Plugin: CommentAnyWay
Plug 'tyru/caw.vim'

let g:caw_no_default_keymappings = 1
map c <Plug>(caw:hatpos:toggle)

":1 Plugin: NERDTree
Plug 'preservim/nerdtree'

" Fast toggle
map ,<Space> :NERDTreeToggle<CR>

let g:NERDTreeMapOpenVSplit = 'a'
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMouseMode = 3            " Single click always
let g:NERDTreeWinPos = 'right'
let g:NERDTreeBookmarksFile = $HOME . '/.vim/.nerdtree-bookmarks'

" Also: ~/.vim/.nerdtree-bookmarks
" Also: ~/.vim/nerdtree_plugin/path_filters.vim

"1 Plugin: NERDTree syntax hightlight
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

let g:NERDTreeSyntaxDisableDefaultExtensions = 1
let g:NERDTreePatternMatchHighlightFullName = 1

":1 Plugin: CtrlP
Plug 'ctrlpvim/ctrlp.vim'

":1 Plugin: Tabular
Plug 'godlygeek/tabular'
" endfold

" Interface
":1 Plugin: Indent Line
Plug 'Yggdroot/indentLine'

":1 Plugin: CSS Color (color previewer)
Plug 'ap/vim-css-color'

":1 Plugin: Goyo
Plug 'junegunn/goyo.vim'

nmap ,g :Goyo<CR>
" endfold

" Completion and code analysis
":1 Plugin: Snipmate
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" Remove start-up message. Ignore deprecated feature
let g:snipMate = {'snippet_version': 1}

" Also: ~/.vim/snippets/
