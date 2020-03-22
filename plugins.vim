" Startup
":1 Plugin: Vundle
Plugin 'VundleVim/Vundle.vim'

let g:vundle_default_git_proto = 'git'

":1 Plugin: LocalRC
Plugin 'thinca/vim-localrc'
" endfold

" Commands
":1 Plugin: TComment
Plugin 'tomtom/tcomment_vim'

":1 Plugin: NERDTree
Plugin 'preservim/nerdtree'

" Fast toggle
map <F2> :NERDTreeToggle<CR>

let g:NERDTreeMapOpenVSplit = 'a'
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMouseMode = 3            " Single click always
let g:NERDTreeWinPos = 'right'
let g:NERDTreeBookmarksFile = $HOME . '/.vim/.nerdtree-bookmarks'

" Also: ~/.vim/.nerdtree-bookmarks
" Also: ~/.vim/nerdtree_plugin/path_filters.vim

":1 Plugin: NERDTree syntax hightlight
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'

let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightColor = {
  \'.*_TESTS$': '3AFFDB',
  \}

":1 Plugin: CtrlP
Plugin 'ctrlpvim/ctrlp.vim'

":1 Plugin: Tabular
Plugin 'godlygeek/tabular'
" endfold

" Interface
":1 Plugin: Jellybeans
Plugin 'nanotech/jellybeans.vim'

let g:jellybeans_overrides = {
  \'Folded':     { 'guifg': '8fbfdc', 'guibg': '151515' },
  \'FoldColumn': { 'guifg': '151515', 'guibg': '151515' },
  \'SignColumn': { 'guifg': '151515', 'guibg': '151515' },
  \}

colorscheme jellybeans

":1 Plugin: CSS Color (color previewer)
Plugin 'ap/vim-css-color'

":1 Plugin: Goyo
Plugin 'junegunn/goyo.vim'

":1 Plugin: Accelerated `jk`
Plugin 'rhysd/accelerated-jk'

":1 Plugin: QF (QuickFix)
Plugin 'romainl/vim-qf'

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
":1 Plugin: Snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

" Also: ~/.vim/snippets/

":1 Plugin: ALE (Asynchronous Lint Engine)
Plugin 'dense-analysis/ale'

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
