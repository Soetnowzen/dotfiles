set nowrap
set noexpandtab

let g:org_todo_keywords = ['TODO(t)', 'ON HOLD(h)', 'WAITING(w)', 'CANCELED(c)', '|', 'DONE(d)', 'DELEGATED(m)']
let g:org_todo_keywords_faces = [['TODO', 'org-warning'], ['ON HOLD', 'yellow'], ['WAITING', 'yellow'], ['CANCELED', 'red'], ['DONE', 'green'], ['DELEGATED', 'green']]

nnoremap <leader>cc :OrgCheckBoxToggle<CR>
nnoremap <leader>cn :OrgCheckBoxNewBelow<CR>
nnoremap <leader>cN :OrgCheckBoxNewAbove<CR>

inoremap <S-CR> :OrgCheckBoxNewBelow<CR>
inoremap <S-C-CR> :OrgCheckBoxNewAbove<CR>
" nnoremap <leader>
