set tabstop=4
set shiftwidth=4
set showbreak=\ \ \ \ 

inoremap <! <!----><Left><Left><Left>
inoremap <expr> - strpart(getline('.'), col('.')-1, 1) == "-" ? "\<Right>" : "-"

function!  MyXmlFoldLevel( lineNumber ) " {
  let thisLine = getline( a:lineNumber )
  if (thisLine =~ '<.*<\/')
    return '='
  elseif ( thisLine =~ '<?')
    return '='
  elseif (thisLine =~ '<\/')
    return "s1"
  elseif ( thisLine =~ '<')
    return "a1"
  endif
  return '='
endfunction " }

setlocal foldexpr=MyXmlFoldLevel(v:lnum)
