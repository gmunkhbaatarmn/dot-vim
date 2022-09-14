set termguicolors                       " Enables 24-bit RGB color in the terminal
set t_vb=                               " No beep or flash on terminal

"1 Plugin: Jellybeans theme
Plug 'nanotech/jellybeans.vim'

let g:jellybeans_overrides = {
  \ 'Folded':     { 'guifg': '8fbfdc', 'guibg': '151515' },
  \ 'FoldColumn': { 'guifg': '151515', 'guibg': '151515' },
  \ 'SignColumn': { 'guifg': '151515', 'guibg': '151515' },
  \ }
"!

let g:NERDTreePatternMatchHighlightColor = {
  \ '.*_TESTS$': '3affdb',
  \ }
