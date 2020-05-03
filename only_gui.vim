set guifont=FiraCodeNerdFontComplete-Regular:h15

":1 Plugin: Papercolor theme
Plug 'NLKNguyen/papercolor-theme'
let g:PaperColor_Theme_Options = {
 \   'theme': {
 \     'default.light': {
 \       'override': {
 \         'folded_bg': ['#eeeeee', '255'],
 \       }
 \     }
 \   }
 \ }
" endfold

let g:NERDTreePatternMatchHighlightColor = {
  \ '.*_TESTS$': '8700af',
  \ }

set macligatures                      " Enable font ligature
set guioptions-=L                     " Remove scroll in splitted window
set guicursor+=n-c:hor10-Cursor       " Change cursor shape to underscore
set guicursor+=a:blinkon0             " Disable cursor blinking

" Window tab settings
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
