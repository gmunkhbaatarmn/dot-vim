call NERDTreeAddPathFilter('NERDTreeCustomIgnoreFilter')

function! NERDTreeCustomIgnoreFilter(params)
  let l:pathlist = [
    \ $HOME . '/Applications',
    \ $HOME . '/Desktop',
    \ $HOME . '/Documents',
    \ $HOME . '/Downloads',
    \ $HOME . '/Dropbox',
    \ $HOME . '/Library',
    \ $HOME . '/Movies',
    \ $HOME . '/Music',
    \ $HOME . '/Pictures',
    \ $HOME . '/Public',
    \ $HOME . '/Sync',
    \ $HOME . '/Sync/Sync.Cache',
    \]

  let l:patterns = [
    \ '\.min\.js$',
    \ '\.min\.css$',
    \ 'Icon\r$',
    \ 'node_modules$',
    \]

  for l:p in l:pathlist
    if a:params['path'].pathSegments == split(l:p, '/')
      return 1
    endif
  endfor

  for l:p in l:patterns
    if a:params['path'].getLastPathComponent(0) =~# l:p
      return 1
    endif
  endfor
endfunction
