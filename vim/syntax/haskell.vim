set autoindent
set foldcolumn=0
set foldlevelstart=99
set foldmethod=indent
set foldnestmax=5
set smartindent
set smarttab

inoremap {-# {-##-}<Left><Left><Left>
" }

" ghc-mod {
nnoremap tw :GhcModeTypeInsert<CR>
nnoremap ts :GhcModeSplitFunCase<CR>
nnoremap tq :GhcModeType<CR>
nnoremap te :GhcModeTypeClear<CR>
" }

let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
