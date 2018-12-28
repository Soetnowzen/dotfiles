
inoremap & &;<Left>
inoremap <expr> ;  strpart(getline('.'), col('.')-1, 1) == ";" ? "\<Right>" : ";"
