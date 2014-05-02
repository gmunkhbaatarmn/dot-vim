" Writer mode
function! Writer()
  set nonumber
  set laststatus=0

  set background=light
  colorscheme macvim
  set background=light

  set fillchars=vert:\ "
  set foldcolumn=12
  set linespace=4
  set guifont=Menlo:h13
  set textwidth=80

  autocmd FileType markdown syn match Quote '^\s*> .*$'
  autocmd Filetype markdown hi Quote guifg=#888888

  hi FoldColumn               guibg=white
  hi Normal                   guibg=gray95
  hi NonText                  guifg=gray95
  hi FoldColumn               guibg=gray95
  hi CursorLine               guibg=gray90
  hi Title                    gui=bold      guifg=gray25
  hi MarkdownHeadingDelimiter gui=bold      guifg=gray25
  hi htmlSpecialChar          guifg=black
  hi markdownBold             gui=bold      guifg=gray25
  hi markdownItalic           guifg=gray25  gui=underline
  hi markdownUrl              guifg=#2fb3a6
  hi markdownAutomaticLink    guifg=#2fb3a6
  hi markdownLinkText         guifg=#317849
  hi markdownUrlTitle         guifg=#317849
  hi markdownBlockquote       guifg=#317849 gui=bold
  hi markdownId               guifg=#2fb3a6
  hi markdownIdDeclaration    guifg=#317849 gui=bold
  hi markdownListMarker       guifg=#317849
  hi Cursor                   guibg=#15abdd
endfunction

command! Writer :call Writer()
