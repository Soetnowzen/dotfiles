
set tabstop=4
set shiftwidth=4

inoreabbrev ifdef ifdef<CR>#endif<Up><End>
inoreabbrev ifndef ifndef<CR>#endif<Up><End>

set foldmethod=syntax
syntax region foldIfNotDef start="#ifndef" end="#endif" transparent fold keepend
syntax region foldIfDef start="#ifdef" end="#endif" transparent fold keepend
