if has('gui_running')
  set guioptions-=T               " Remove toolbar
  set guioptions-=l               " Remove scroll
  set guioptions-=L               " Remove scroll in splitted window
  set guicursor+=n-c:hor10-Cursor " Change cursor shape to underscore
  set guicursor+=a:blinkon0       " Disable cursor blinking
endif

if has('gui_running') && has('gui_macvim')
  set macligatures
  set guifont=Fira\ Code:h15      " Change GUI font
  set visualbell                  " Disable error sound

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
endif
