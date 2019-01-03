
set tabstop=4
set shiftwidth=4
set noexpandtab
set showbreak=\ \ \ \ 

inoreabbrev ifdef ifdef<CR>endif<Up><End>
inoreabbrev ifndef ifndef<CR>endif<Up><End>
inoreabbrev ifeq ifeq<CR>endif<Up><End><Space>(,)<Left><Left>
inoreabbrev ifneq ifneq<CR>endif<Up><End><Space>(,)<Left><Left>
inoreabbrev if if<CR>fi<Up><End><Space>[]; then<Left><Left><Left><Left><Left><Left><Left>
inoreabbrev elif elif<Space>[]; then<Left><Left><Left><Left><Left><Left><Left>

set foldmethod=indent
