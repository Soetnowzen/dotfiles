
inoremap & &;<Left>
inoremap <expr> ;  strpart(getline('.'), col('.')-1, 1) == ";" ? "\<Right>" : ";"

inoremap @start @startuml<CR>@enduml<Up><End>
inoremap @startuml @startuml<CR>@enduml<Up><End>

inoreabbrev if if<CR>endif<Up><End><Space>() then ()<Left><Left><Left><Left><Left><Left><Left><Left><Left>
inoreabbrev else else()<Left>
inoreabbrev alt alt<CR>end alt<Up><End>
inoreabbrev note note<CR>end note<Up><End>
inoreabbrev opt opt<CR>end opt<Up><End>

function!  MyMdFoldLevel( lineNumber ) " {
  let thisLine = getline( a:lineNumber )
  " = No folding
  " a1 Step in
  " s1 Step out
  if (thisLine =~ '<.*\/>')
    return '='
  elseif (thisLine =~ '<!.*>')
    return '='
  elseif (thisLine =~ '<.*<\/')
    return '='
  elseif ( thisLine =~ '<?')
    return '='
  elseif (thisLine =~ '<!--')
    return "a1"
  elseif ( thisLine =~ '-->')
    return "s1"
  elseif (thisLine =~ '<\/')
    return "s1"
  elseif ( thisLine =~ '<')
    return "a1"
  endif
  return '='
endfunction " }

setlocal foldexpr=MyMdFoldLevel(v:lnum)
