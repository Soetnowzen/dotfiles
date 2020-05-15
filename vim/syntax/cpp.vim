" set syntax=cpp.doxygen

set tabstop=2
set shiftwidth=2

inoreabbrev #d #define
inoreabbrev #i #include
inoreabbrev ifdef ifdef<CR>#endif<Up><End>
inoreabbrev ifndef ifndef<CR>#endif<Up><End>
inoreabbrev p printf("\n");<Left><Left><Left><Left><Left>
" inoreabbrev #if #if<CR>#endif<Up><End>
inoreabbrev class class<CR>{<CR>};<Up><Up><Up><End>

set foldmethod=syntax
syntax region foldIfNotDef start="#ifndef" end="#endif" transparent fold keepend
syntax region foldIfDef start="#ifdef" end="#endif" transparent fold keepend

