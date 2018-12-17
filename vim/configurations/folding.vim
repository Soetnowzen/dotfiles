set foldcolumn=1
" highlight clear Folded
highlight Folded cterm=Bold gui=Bold

function! MyFoldLevel( lineNumber ) " {
  let thisLine = getline( a:lineNumber )
  " Don't create fold if entire comment or {} pair is on one line.
  if (thisLine =~ '\%(/\*.*\*/\)')
    return '='
  elseif ( thisLine =~ '/\*')
    return "a1"
  elseif ( thisLine =~ '\*/')
    return "s1"
  elseif ( thisLine =~ '\%({.*}\)')
    return '='
  elseif ( thisLine =~ '{')
    return "a1"
  elseif (thisLine =~ '}')
    return "s1"
  elseif ( thisLine =~ '\%(\[.*\]\)' )
    return '='
  elseif ( thisLine =~ '\[')
    return "a1"
  elseif (thisLine =~ '\]')
    return "s1"
  elseif ( thisLine =~ '\(#if\(def\|ndef\)\?\)' )
    return "a1"
  elseif (thisLine =~ '\(#endif\)' )
    return "s1"
  endif
  return '='
endfunction
" }

setlocal foldexpr=MyFoldLevel(v:lnum)
setlocal foldmethod=expr
augroup syntax_folding " {
  autocmd!
  autocmd FileType java set foldmethod=syntax
  autocmd FileType plaintex,gdb set foldmethod=indent
  autocmd FileType java set foldenable
  " autocmd FileType java syntax clear javaBraces
  " autocmd FileType java syntax clear javaDocComment
  " autocmd FileType java syntax region foldBraces start=/{/ end=/}/ transparent fold keepend extend
  autocmd FileType java syntax region foldJavadoc start=+/\*+ end=+\*/+ transparent fold keepend
  autocmd FileType java syntax region foldBrackets start="\[" end="]" transparent fold keepend
  autocmd FileType java syntax region foldParenthesis start="(" end=")" transparent fold keepend
  autocmd FileType java set foldlevel=0
  autocmd FileType java set foldnestmax=10
augroup END
" }

set foldtext=MyFoldText()
function MyFoldText() " {
  let line = getline(v:foldstart)
  let tabStop = repeat(' ', &tabstop)
  let line = substitute(line, '\t', tabStop, 'g')
  let number_of_lines = v:foldend - v:foldstart + 1
  return  line . ' ' . v:folddashes . ' +' . number_of_lines . ' ☰ '
endfunction
" }

set fillchars=vert:\|,fold:-
