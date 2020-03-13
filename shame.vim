" This file is for:
" 1. not decided where to put the code
" 2. ugly codes that need refactor

":1 Dvorak: 'hjkl' change
" left, down, up, right
noremap d <left>
noremap h g<down>
noremap t g<up>
noremap n <right>

" delete text (was: move down)
noremap j d
" disabled    (was: move up)
noremap k <nop>
" search next (was: move to right character)
noremap l n
" search prev (was: move to up line)
noremap L N

" up, down leap
noremap H 6g<Down>
noremap T 6g<Up>

" goto line beginning
noremap D ^
noremap _ ^

" goto line end
noremap N $
noremap - $

" to command line mode
noremap s :
noremap S :

":1 Dvorak: NERDTree
let g:NERDTreeMapOpenInTab = '<C-S-t>'
let g:NERDTreeMapOpenInTabSilent='<C-S-D>'
" endfold

":1 NERDTree syntax hightlight
" let g:NERDTreeFileExtensionHighlightFullName = 1
" let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
" let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_TESTS$'] = '3AFFDB'
" endfold

" Identify the syntax hightlighting group used at the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Highlight over length lines
highlight OverLength ctermbg=red ctermfg=white guibg=#592929

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

":1 :ProseMode
function! ProseMode()
  call goyo#execute(0, [])
  set nocopyindent
  set nosmartindent noai nolist noshowmode noshowcmd
  set complete+=s
endfunction

command! ProseMode call ProseMode()
