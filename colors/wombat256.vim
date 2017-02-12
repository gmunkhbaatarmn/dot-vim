" Vim color file
" wombat256.vim - a modified version of Wombat by Lars Nielsen that also
" works on xterms with 88 or 256 colors. The algorithm for approximating the
" GUI colors with the xterm palette is from desert256.vim by Henry So Jr.

set background=dark

let g:colors_name = 'wombat256'

if !has('gui_running') && &t_Co !=# 256
  finish
endif

":1 Declare functions
" returns an approximate grey index for the given grey level
function <SID>grey_number(x)
  if a:x < 14
    return 0
  else
    let l:n = (a:x - 8) / 10
    let l:m = (a:x - 8) % 10
    if l:m < 5
      return l:n
    else
      return l:n + 1
    endif
  endif
endfun

" returns the actual grey level represented by the grey index
fun <SID>grey_level(n)
  if a:n == 0
    return 0
  else
    return 8 + (a:n * 10)
  endif
endfun

" returns the palette index for the given grey index
fun <SID>grey_color(n)
  if a:n == 0
    return 16
  elseif a:n == 25
    return 231
  else
    return 231 + a:n
  endif
endfun

" returns an approximate color index for the given color level
fun <SID>rgb_number(x)
  if a:x < 75
    return 0
  else
    let l:n = (a:x - 55) / 40
    let l:m = (a:x - 55) % 40
    if l:m < 20
      return l:n
    else
      return l:n + 1
    endif
  endif
endfun

" returns the actual color level for the given color index
fun <SID>rgb_level(n)
  if a:n == 0
    return 0
  else
    return 55 + (a:n * 40)
  endif
endfun

" returns the palette index for the given R/G/B color indices
fun <SID>rgb_color(x, y, z)
  return 16 + (a:x * 36) + (a:y * 6) + a:z
endfun

" returns the palette index to approximate the given R/G/B color levels
fun <SID>color(r, g, b)
  " get the closest grey
  let l:gx = <SID>grey_number(a:r)
  let l:gy = <SID>grey_number(a:g)
  let l:gz = <SID>grey_number(a:b)

  " get the closest color
  let l:x = <SID>rgb_number(a:r)
  let l:y = <SID>rgb_number(a:g)
  let l:z = <SID>rgb_number(a:b)

  if l:gx == l:gy && l:gy == l:gz
    " there are two possibilities
    let l:dgr = <SID>grey_level(l:gx) - a:r
    let l:dgg = <SID>grey_level(l:gy) - a:g
    let l:dgb = <SID>grey_level(l:gz) - a:b
    let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
    let l:dr = <SID>rgb_level(l:gx) - a:r
    let l:dg = <SID>rgb_level(l:gy) - a:g
    let l:db = <SID>rgb_level(l:gz) - a:b
    let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
    if l:dgrey < l:drgb
      " use the grey
      return <SID>grey_color(l:gx)
    else
      " use the color
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  else
    " only one possibility
    return <SID>rgb_color(l:x, l:y, l:z)
  endif
endfun

" returns the palette index to approximate the 'rrggbb' hex string
fun <SID>rgb(rgb)
  let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
  let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
  let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0
  return <SID>color(l:r, l:g, l:b)
endfun

" sets the highlighting for the given group
fun <SID>X(group, fg, bg, attr)
  if a:fg !=# ''
    exec 'hi '. a:group .' guifg=#'. a:fg .' ctermfg='. <SID>rgb(a:fg)
  else
    exec 'hi '. a:group .' guifg=NONE        ctermfg=NONE'
  endif

  if a:bg !=# ''
    exec 'hi '. a:group .' guibg=#'. a:bg .' ctermbg='. <SID>rgb(a:bg)
  else
    exec 'hi '. a:group .' guibg=NONE        ctermbg=NONE'
  endif

  if a:attr ==# 'italic'
    exec 'hi '. a:group .' gui='. a:attr .' cterm=NONE'
  elseif a:attr !=# ''
    exec 'hi '. a:group .' gui='. a:attr .' cterm='. a:attr
  endif
endfun
" endfold

call <SID>X('Normal',       'cccccc', '242424', 'none')
call <SID>X('Cursor',       '222222', 'aaaaaa', 'none')
call <SID>X('CursorLine',   '',       '32322e', 'none')
call <SID>X('CursorColumn', '',       '2d2d2d', '')
            "CursorIM
            "Question
            "IncSearch

call <SID>X('Search',       '444444', 'af87d7', '')
call <SID>X('MatchParen',   'ecee90', '857b6f', 'bold')
call <SID>X('SpecialKey',   '6c6c6c', '242424', 'none')
call <SID>X('NonText',      '6c6c6c', '242424', 'none')
call <SID>X('Visual',       'ecee90', '597418', 'none')
" call <SID>X('LineNr',       '857b6f', '121212', 'none')
call <SID>X('LineNr',       '999999', '242424', 'none')
call <SID>X('Folded',       'af87d7', '242424', 'none')
call <SID>X('Title',        'f6f3e8', '',       'bold')
call <SID>X('VertSplit',    '444444', '444444', 'none')
call <SID>X('StatusLine',   'f6f3e8', '444444', 'italic')
call <SID>X('StatusLineNC', '857b6f', '444444', 'none')
            "Scrollbar
            "Tooltip
            "Menu
            "WildMenu

call <SID>X('Pmenu',        'f6f3e8', '444444', '')
call <SID>X('PmenuSel',     '121212', 'caeb82', '')
call <SID>X('WarningMsg',   'ff0000', '',       '')
            "ErrorMsg
            "ModeMsg
            "MoreMsg
            "Directory
            "DiffAdd
            "DiffChange
            "DiffDelete
            "DiffText

" syntax highlighting
call <SID>X('Number',       'e5786d', '',       'none')
call <SID>X('Constant',     'e5786d', '',       'none')
call <SID>X('String',       '95e454', '',       'italic')
call <SID>X('Comment',      'c0bc6c', '',       'italic')
call <SID>X('Identifier',   'caeb82', '',       'none')
call <SID>X('Keyword',      '87afff', '',       'none')
call <SID>X('Statement',    '87afff', '',       'none')
call <SID>X('Function',     'caeb82', '',       'none')
call <SID>X('PreProc',      'e5786d', '',       'none')
call <SID>X('Type',         'caeb82', '',       'none')
call <SID>X('Special',      'ffdead', '',       'none')
call <SID>X('Todo',         '857b6f', '',       'italic')
            "Underlined
            "Error
            "Ignore

hi! link VisualNOS Visual
" hi! link NonText LineNr
" hi! link FoldColumn Folded
call <SID>X('FoldColumn',   '242424', '242424', 'none')

":1 Delete functions
delfunction <SID>X
delfunction <SID>rgb
delfunction <SID>color
delfunction <SID>rgb_color
delfunction <SID>rgb_level
delfunction <SID>rgb_number
delfunction <SID>grey_color
delfunction <SID>grey_level
delfunction <SID>grey_number
" endfold
