" Writer mode
function! Writer()
  set nonumber
  set laststatus=0

  set background=light
  if system('uname') =~# 'Darwin'
    colorscheme macvim
    set guifont=Menlo:h13
  else
    colorscheme solarized
    set guifont=DejaVu:h13
  endif
  set background=light

  set fillchars=vert:\ "
  set foldcolumn=12
  set linespace=4
  set textwidth=80

  autocmd vimrc FileType markdown syn match Quote '^\s*> .*$'
  autocmd vimrc Filetype markdown hi Quote guifg=#888888

  autocmd vimrc BufEnter markdown syn match Braces display '[{}()\[\]]'
  autocmd vimrc BufEnter markdown hi def link Braces comment

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
