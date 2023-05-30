" Vundle {
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'AndrewRadev/linediff.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'dense-analysis/ale'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'elzr/vim-json'
Plugin 'gmarik/Vundle.vim'
Plugin 'jceb/vim-orgmode'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'scrooloose/nerdtree'
Plugin 'skywind3000/vim-auto-popmenu'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-python/python-syntax'
Plugin 'wesQ3/vim-windowswap'

call vundle#end()
filetype plugin indent on
" }

" Colors {
" Sets colors based on a dark background
syntax enable
let g:solarized_bold=1 " 0 | 1
let g:solarized_hitrail=1 " 0 | 1
let g:solarized_italic=1 " 0 | 1
let g:solarized_termcolors=16 " 16 | 256
let g:solarized_termtrans=1 " 0 | 1
let g:solarized_underline=1 " 0 | 1
if has('gui_running')
	" if GVim else Vim
	let g:solarized_contrast="high" " low | normal | high
	let g:solarized_visibility="high" " low | normal | high
	set background=light " light | dark

	" Window Size
	if exists("+columns")
		set columns=90
	endif
	if exists("+lines")
		set lines=64
	endif
else
	set t_Co=256
	let g:solarized_contrast = "high" " low | normal | high
	let g:solarized_visibility = "high" " low | normal | high
	set background=dark
endif
colorscheme solarized

set colorcolumn+=81
set colorcolumn+=82
set colorcolumn+=83
set colorcolumn+=101
set colorcolumn+=102
set colorcolumn+=103
set colorcolumn+=121
set colorcolumn+=122
set colorcolumn+=123
" }

" vim-fugitive {
augroup vim_fugitive " {
	autocmd!
	autocmd QuickFixCmdPost *grep* cwindow
augroup END
"   }
" }

" python-syntax {
let g:python_highlight_all = 1
" }

" vim-json {
let g:vim_json_syntax_conceal = 0
" }

" vim-windowswap {
nnoremap <C-y>w :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <Leader>y :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <C-p>w :call WindowSwap#DoWindowSwap()<CR>
nnoremap <Leader>p :call WindowSwap#DoWindowSwap()<CR>
nnoremap <C-w>w :call WindowSwap#EasyWindowSwap()<CR>
nnoremap <Leader>w :call WindowSwap#EasyWindowSwap()<CR>
" }

" linediff {
noremap \ldt :Linediff<CR>
noremap \ldo :LinediffReset<CR>
vnoremap <Leader>d :Linediff<CR>
nnoremap <Leader>r :LinediffReset<CR>
" }

" Airline {
" :AirlineTheme solarized
if has('gui_running')
	let g:airline_solarized_bg='light'
else
	let g:airline_solarized_bg='dark'
endif

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_detect_spell=1
let g:airline_detect_spelllang=1
let g:airline_left_sep = '>'
" let g:airline_left_sep = '▶'
let g:airline_right_sep = '<'
" old vim-powerline symbols
" let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '>>'
" let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '<<'
" let g:airline_symbols.branch = '<-'
" let g:airline_symbols.readonly = '<->'
" let g:airline_symbols.linenr = '^'        "
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_inactive_collapse=1
function! AirlineInit() " {
	let g:airline_section_a = airline#section#create(['mode', 'B', 'branch'])
	let g:airline_section_b = airline#section#create_left(['ffenc', 'hunks', '%f'])
	let g:airline_section_c = airline#section#create(['filetype'])
	let g:airline_section_x = airline#section#create(['%P'])
	let g:airline_section_y = airline#section#create(['%B'])
	let g:airline_section_z = airline#section#create_right(['%l', '%c'])
endfunction
"   }
autocmd VimEnter * call AirlineInit()
" }

" vim-cpp-enhanced-highlight {
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
" let g:cpp_experimental_simple_template_highlight = 1  " Or
let g:cpp_experimental_template_highlight = 1
let g:cpp_no_function_highlight = 1
" }

" NERDTree {
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore =
			\ ['\.pyc$', '\.hi$', '\.o$', '\.dyn_hi$', '\.dyn_o$', '\.exe$',
			\ '\.swp$', '\.bak$', '\.pyc$', '\.class$', '\~$']
let NERDTreeWinSize = 42
let NERDTreeQuitOnOpen = 1
let NERDTreeDirArrows = 0
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenVSplit='v'
" }

" vim-gitgutter {
if exists('&signcolumn') " Vim 7.4.2201
	set signcolumn=yes
else
	let g:gitgutter_sign_column_always = 1
endif

let g:gitgutter_diff_args = '-w'
" }

" Asynchronous Lint Engine (ALE) {
let b:ale_linters= {
			\ 'python': ['flake8', 'pylint']
			\ }
let b:ale_fixers = {
			\ '*': ['remove_trailing_lines', 'trim_whitespace'],
			\ 'cpp': ['clang-format'],
			\ 'javascript': ['prettier', 'eslint', 'clang-format'],
			\ 'json': ['clang-format', 'prettier'],
			\ 'python': ['autopep8', 'yapf']
			\ }

" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1

" Use with <C-x><C-o>
set omnifunc=ale#completion#OmniFunc

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

" Show 5 lines of errors (default: 10)
let g:ale_list_window_size = 5
" }

" auto-popmenu {
" enable this plugin for filestypes, '*' for all files.
let g:apc_enable_ft = {
			\ 'text': 1,
			\ 'markdown': 1,
			\ 'php': 1,
			\ 'javascript': 1,
			\ 'json': 1
			\ }

" source for dictionary, current or other loaded buffers, see ':help cpt'
set cpt=.,k,w,b

" don't select the first item.
" set completeopt=menu,menuone,noselect
set completeopt=menu,longest,preview,noselect

" Suppress annoy messages.
set shortmess+=c
" }
