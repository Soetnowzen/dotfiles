" Vundle {
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'AndrewRadev/linediff.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'elzr/vim-json'
Plugin 'gmarik/Vundle.vim'
Plugin 'jceb/vim-orgmode'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-python/python-syntax'
Plugin 'vim-syntastic/syntastic'
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

" Syntastic stuff {
function! s:get_cabal_sandbox() " {
  if filereadable('cabal.sandbox.config')
	let l:output = system('cat cabal.sandbox.config | grep local-repo')
	let l:dir = matchstr(substitute(l:output, '\n', ' ', 'g'), 'local-repo: \zs\S\+\ze\/packages')
	return '-s ' . l:dir
  else
	return ''
  endif
endfunction
"   }

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_enable_signs = 1
let g:syntastic_haskell_ghc_mod_args = s:get_cabal_sandbox()

" let g:syntastic_python_checkers = ['python', 'flake8']
let g:syntastic_python_checkers = ['python3', 'pylint']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
" let g:syntastic_cpp_checkers = ['clang_cpp', 'gcc']
" let g:syntastic_cpp_checkers = ['clang_check', 'gcc']
let g:syntastic_cpp_checkers = []
let g:syntastic_erl_checkers = ['Dialyzer'] " untested
let g:syntastic_js_checkers = ['JSHint'] " untested
let g:syntastic_java_checkers = ['PMD'] " untested

" let g:syntastic_c_cflags = '-I/usr/include/lib'

let g:syntastic_cpp_include_dirs =
      \ ['../include', 'include', 'includes', 'headers', '/\*\*/inc',
      \ '../../inc', '../inc', 'inc', '/\*\*/export', '../../export',
      \ '../export', 'export', '../../src', '../src', 'src', '../test/bin',
      \ 'test/bin']
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
" let g:syntastic_cpp_compiler = 'gcc'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++ -D_FORTIFY_SOURCE=1'
let g:syntastic_enable_signs = 1

function! FindConfig(prefix, what, where) " {
  let cfg = findfile(a:what, escape(a:where, ' ') . ';')
  return cfg !=# '' ? ' ' . a:prefix . ' ' . shellescape(cfg) : ''
endfunction
"   }

augroup syntastic " {
  autocmd!
  autocmd FileType c,cpp,objc let b:syntastic_cpp_cpplint_args =
		\ get(g:, 'syntastic_cpp_cpplint_args', '') .
		\ FindConfig('-c', '.h', expand('<afile>:p:h', 1))

  autocmd FileType javascript let b:syntastic_javascript_jscs_args =
		\ get(g:, 'syntastic_javascript_jscs_args', '') .
		\ FindConfig('-c', '.jscsrc', expand('<afile>:p:h', 1))
augroup END
"   }
" }

" vim-gitgutter {
if exists('&signcolumn') " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

let g:gitgutter_diff_args = '-w'
" }

