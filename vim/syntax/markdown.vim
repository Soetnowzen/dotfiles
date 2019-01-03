
inoremap & &;<Left>
inoremap <expr> ;  strpart(getline('.'), col('.')-1, 1) == ";" ? "\<Right>" : ";"

inoremap @start @startuml<CR>@enduml<Up><End>
inoremap @startuml @startuml<CR>@enduml<Up><End>

inoremap if<Space> if<CR>endif<Up><End><Space>() then ()<Left><Left><Left><Left><Left><Left><Left><Left><Left>
inoremap else else()<Left>
