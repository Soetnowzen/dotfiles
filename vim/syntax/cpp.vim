
set tabstop=4
set shiftwidth=4

inoremap #ifdef<Space> #ifdef<CR>#endif<Up><End><Space>
inoremap #ifndef<Space> #ifndef<CR>#endif<Up><End><Space>

set foldmethod=syntax
syntax region foldIfNotDef start="#ifndef" end="#endif" transparent fold keepend
syntax region foldIfDef start="#ifdef" end="#endif" transparent fold keepend
