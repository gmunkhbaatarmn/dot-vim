function! g:SnippetsFoldExpr() "
  "2 +1 | `^snippet `
  if getline(v:lnum) =~? '^snippet '
    return '>1'
  endif "!2

  "2 -1 | `^#!$`
  if getline(v:lnum) =~? '^#!$'
    return '<1'
  endif "!2

  return '='
endfunction "!

" use tab. tabsize = 2
autocmd vimrc FileType snippets
  \   setlocal tabstop=2
  \ | setlocal shiftwidth=2
  \ | setlocal noexpandtab

autocmd vimrc FileType snippets
  \   setlocal foldmethod=expr
  \ | setlocal foldexpr=g:SnippetsFoldExpr()
  \ | setlocal foldtext=getline(v:foldstart)
