" For each plugin:
"
"   - Command
"   - Mapping

" Commands
":1 Plugin: CommentAnyWay
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

":1 Plugin: NERDTree syntax hightlight
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

let g:NERDTreeSyntaxDisableDefaultExtensions = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightColor = {
  \ '.*_TESTS$': '3AFFDB',
  \ }

":1 Plugin: CtrlP
Plug 'ctrlpvim/ctrlp.vim'

":1 Plugin: Tabular
Plug 'godlygeek/tabular'
" endfold

" Interface
":1 Plugin: Jellybeans
Plug 'nanotech/jellybeans.vim'

let g:jellybeans_overrides = {
  \ 'Folded':     { 'guifg': '8fbfdc', 'guibg': '151515' },
  \ 'FoldColumn': { 'guifg': '151515', 'guibg': '151515' },
  \ 'SignColumn': { 'guifg': '151515', 'guibg': '151515' },
  \ }

":1 Plugin: CSS Color (color previewer)
Plug 'ap/vim-css-color'

":1 Plugin: Goyo
Plug 'junegunn/goyo.vim'
nmap ,g :Goyo<CR>

":1 Plugin: Accelerated `jk`
Plug 'rhysd/accelerated-jk'

":1 Plugin: QF (QuickFix)
Plug 'romainl/vim-qf'

let g:qf_auto_quit = 0
let g:qf_auto_resize = 0

function! g:QFToggle(stay)
  " Just a copy of `vim-qf` plugin's `ToggleQfWindow(stay)`
  " But uses `copen` instead of `cwindow`

  ":2 ...
  " save the view if the current window is not a quickfix window
  if get(g:, 'qf_save_win_view', 1)  && !qf#IsQfWindow(winnr())
    let winview = winsaveview()
  else
    let winview = {}
  endif

  " if one of the windows is a quickfix window close it and return
  if qf#IsQfWindowOpen()
    cclose
    if !empty(winview)
      call winrestview(winview)
    endif
  else
    copen
    if qf#IsQfWindowOpen()
      wincmd p
      if !empty(winview)
        call winrestview(winview)
      endif
      if !a:stay
        wincmd p
      endif
    endif
  endif
  " endfold2
endfunction

nmap <C-f> :call g:QFToggle(1)<CR>
" endfold

" Completion and code analysis
":1 Plugin: AsyncComplete
Plug 'prabirshrestha/asyncomplete.vim'

let g:asyncomplete_auto_popup = 0

imap <c-space> <Plug>(asyncomplete_force_refresh)
imap <c-@>     <Plug>(asyncomplete_force_refresh)

":1 Plugin: LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Install: pip install python-language-server
if executable('pyls')
  autocmd vimrc User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': {server_info->['pyls']},
    \ 'whitelist': ['python'],
    \ })
endif

":1 Plugin: Snipmate
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" Also: ~/.vim/snippets/

":1 Plugin: ALE (Asynchronous Lint Engine)
Plug 'dense-analysis/ale'

let g:ale_linters_explicit = 1         " Linters disabled in default
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_keep_list_window_open = 0
let g:ale_set_signs = 0
let g:ale_set_highlights = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_linters = {}

highlight link ALEErrorLine error
highlight link ALEWarningLine warning
