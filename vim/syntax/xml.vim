set tabstop=4
set shiftwidth=4
set showbreak=\ \ \ \ 

inoremap <! <!----><Left><Left><Left>
inoremap <expr> - strpart(getline('.'), col('.')-1, 1) == "-" ? "\<Right>" : "-"
