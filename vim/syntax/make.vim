
set tabstop=4
set shiftwidth=4
set noexpandtab
set showbreak=\ \ \ \ 

inoremap ifdef<Space> ifdef<CR>endif<Up><End><Space>
inoremap ifndef<Space> ifndef<CR>endif<Up><End><Space>
inoremap ifeq<Space> ifeq<CR>endif<Up><End><Space>(,)<Left><Left>
inoremap ifneq<Space> ifneq<CR>endif<Up><End><Space>(,)<Left><Left>
inoremap if<Space> if<CR>fi<Up><End><Space>[]; then<Left><Left><Left><Left><Left><Left><Left>
inoremap elif<Space> elif<Space>[]; then<Left><Left><Left><Left><Left><Left><Left>
