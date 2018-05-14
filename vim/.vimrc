set encoding=utf-8
set fileencoding=utf-8
set nocompatible
filetype off
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

let &t_SI .= "\<Esc>[5 q" " ]
let &t_EI .= "\<Esc>[1 q" " ]

" Misc {
" Sets row numbers
set number

set tags+=/

" Cursor marking
set cursorline
set cursorcolumn

" Leave a few lines when scrolling
set scrolloff=3
set sidescrolloff=5

" Bell
set noerrorbells
set visualbell

" Set the window's title, reflecting the file currently being edited.
set title

" Automatically re-read files if unmodified inside Vim
set autoread

" Delete coment characters when joining lines.
set formatoptions+=j

" Change the mapleader from \ to ,
let mapleader=","

" set System clipboard
set clipboard=unnamed

" more autocomplete <Ctrl>-P options
set completeopt=menu,longest,preview

set wildchar=<Tab> wildmenu wildmode=full

set splitbelow
set splitright

" Show autocompletion options
set wildmenu
set wildmode=list:longest,full

" Show hidden characters with given characters
" highlight NonText ctermfg=Magenta guifg=Magenta
highlight SpecialKey ctermfg=Magenta guifg=Magenta
set list
set listchars=tab:>-
set listchars+=trail:-
set listchars+=conceal:C  " conceallevel is set to 1
set listchars+=nbsp:%  " Non-breakable space
set listchars+=extends:>,precedes:<

set linebreak
set showbreak=->
au FileType python,perl set showbreak=--->
set cpoptions+=n
set breakindent
set breakat+=>

set switchbuf+=useopen
set switchbuf+=usetab
set switchbuf+=split

" :e ignores files
set wildignore=*.o,*.exe,*.hi,*.swp,*.bak,*.pyc,*.class

au BufRead,BufNewFile *.log set filetype=log
au BufRead,BufNewFile *.txt set filetype=text
au BufRead,BufNewFile *.json set filetype=json
" }

" ToggleComment {
let s:comment_map = {
      \   "ahk": ';',
      \   "bash_profile": '#',
      \   "bashrc": '#',
      \   "bat": 'REM',
      \   "c": '\/\/',
      \   "conf": '#',
      \   "cpp": '\/\/',
      \   "desktop": '#',
      \   "eml": '>',
      \   "fstab": '#',
      \   "gitconfig": '#',
      \   "go": '\/\/',
      \   "java": '\/\/',
      \   "javascript": '\/\/',
      \   "lua": '--',
      \   "mail": '>',
      \   "make": '#',
      \   "php": '\/\/',
      \   "profile": '#',
      \   "python": '#',
      \   "ruby": '#',
      \   "rust": '\/\/',
      \   "scala": '\/\/',
      \   "sh": '#',
      \   "spec": '#',
      \   "tcsh": '#',
      \   "tex": '%',
      \   "tmux": "#",
      \   "vim": '"',
      \ }

function! ToggleComment()
  " Skip if row only are whitespaces
  if getline('.') !~ "^\\s*$"
    if has_key(s:comment_map, &filetype)
      let comment_leader = s:comment_map[&filetype]
      if getline('.') =~ "^\\s*" . comment_leader . " "
        " Uncomment the line
        execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
      else
        if getline('.') =~ "^\\s*" . comment_leader
          " Uncomment the line
          execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
        else
          " Comment the line
          execute "silent s/^\\(\\s*\\)/\\1" . comment_leader . " /"
        end
      end
    else
      echo "No comment leader found for filetype"
    end
  end
endfunction

nnoremap <leader><Space> :call ToggleComment()<cr>
vnoremap <C-m> :call ToggleComment()<cr>
nnoremap <C-m> :call ToggleComment()<cr>
" }

" Mapping {
" unmap ctrl + Y
iunmap <C-Y>

" Avoid mswin.vim making Ctrl-v ac as paste
noremap <C-v> <C-v>

" Navigate wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <Left> <C-W><
nnoremap <Right> <C-W>>
nnoremap <Up> <C-W>+
nnoremap <Down> <C-W>-
nnoremap H gT
nnoremap L gt
nnoremap Q gqap
" move to beginning/end of line
nnoremap B ^
nnoremap E $

map Y y$

" Command-line mode remaps
cnoremap jj <Esc>
cnoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
cnoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
cnoremap { {}<Left>
cnoremap < <><Left>
cnoremap <<Space> <<Space>
cnoremap <expr> >  strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
cnoremap [ []<Left>
" [
cnoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
cnoremap ( ()<Left>
cnoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

" normal mode remap case switch
nnoremap § ~

" visual mode remap case switch
vnoremap § ~
vnoremap Q gq

nnoremap <Space> :noh<cr>

" Insertion mode remaps
inoremap :w<CR> <Esc>:w<CR>a
inoremap :wq<CR> <Esc>:wq<CR>
inoremap jj <Esc>
nnoremap <C-CR> <Esc>o
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
" }}
" {
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap < <><Left>
inoremap <<Space> <<Space>
inoremap << <
inoremap <<<Space> <<<Space>
inoremap <expr> >  strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
inoremap [ []<Left>
inoremap [<Space> [<Space><Space>]<Left><Left>
" [
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap ( ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap /* /**/<Left><Left>
inoremap /*<BS> <NOP>
inoremap /*<BS><BS> <NOP>
inoremap /*<Space> /*<Space><Space>*/<Left><Left><Left>
inoremap /*<CR> /*<CR>*/<Esc>O
inoremap """<CR> """<CR>"""<Esc>O
inoremap """<Space> """<Space><Space>"""<Left><Left><Left><Left>
inoremap '''<CR> '''<CR>'''<Esc>O
inoremap '''<Space> '''<Space><Space>'''<Left><Left><Left><Left>
inoremap ,, <End>,
inoremap ;; <End>;

let pairing_characters = ["[]", "{}", "''", "\"\"", "()", "**", "\/\/", "<>", "  "]
inoremap <expr> <BS>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<Right>\<BS>\<BS>" : "\<BS>"
cnoremap <expr> <BS>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<Right>\<BS>\<BS>" : "\<BS>"

au FileType plaintex,text call Inoremaps()
fu! Inoremaps()
  inoremap <Space>alpha<Space> <Space>α<Space>
  inoremap <Space>beta<Space> <Space>Β<Space>
  inoremap <Space>gamma<Space> <Space>γ<Space>
  inoremap <Space>delta<Space> <Space>δ<Space>
  inoremap <Space>epsilon<Space> <Space>ε<Space>
  inoremap <Space>zeta<Space> <Space>ζ<Space>
  inoremap <Space>eta<Space> <Space>η<Space>
  inoremap <Space>theta<Space> <Space>θ<Space>
  inoremap <Space>lambda<Space> <Space>λ<Space>
  inoremap <Space>mu<Space> <Space>μ<Space>
  inoremap <Space>pi<Space> <Space>π<Space>
  inoremap <Space>rho<Space> <Space>ρ<Space>
  inoremap <Space>sigma<Space> <Space>σ<Space>
  inoremap <Space>tau<Space> <Space>τ<Space>
  inoremap <Space>phi<Space> <Space>φ<Space>
  inoremap <Space>psi<Space> <Space>ψ<Space>
  inoremap <Space>omega<Space> <Space>ω<Space>
  inoremap <Space>Gamma<Space> <Space>Γ<Space>
  inoremap <Space>Delta<Space> <Space>Δ<Space>
  inoremap <Space>Theta<Space> <Space>Θ<Space>
  inoremap <Space>Lambda<Space> <Space>Λ<Space>
  inoremap <Space>Pi<Space> <Space>Π<Space>
  inoremap <Space>Sigma<Space> <Space>Σ<Space>
  inoremap <Space>Phi<Space> <Space>Φ<Space>
  inoremap <Space>Psi<Space> <Space>Ψ<Space>
  inoremap <Space>Omega<Space> <Space>Ω<Space>
  inoremap <Space>forall<Space> <Space>∀<Space>
  inoremap <Space>exists<Space> <Space>∃<Space>
  inoremap <Space>notexists<Space> <Space>∄<Space>
  inoremap <Space>emptyset<Space> <Space>∅<Space>
  inoremap <Space>in<Space> <Space>∈<Space>
  inoremap <Space>notin<Space> <Space>∉<Space>
  inoremap <Space>sqrt<Space> <Space>√<Space>
  inoremap <Space>infinit<Space> <Space>∞<Space>
  inoremap && ∧
  " inoremap || ∨
  inoremap <Space>intersection<Space> <Space>∩<Space>
  inoremap <Space>union<Space> <Space>∪<Space>
  inoremap <Space>integral<Space> <Space>∫<Space>
  inoremap ~= ≃
  inoremap != ≠
  inoremap >= ≥
  inoremap <= ≤
  inoremap ... ⋯
endfu
" }

" Spelling {
iab anf and
iab adn and
iab ans and
iab teh the
iab thre there

au FileType text,plaintex,sh,cpp,vim set spell spelllang=en_us
" }

autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete

" Folding {
function! MyFoldLevel( lineNumber )
  let thisLine = getline( a:lineNumber )
  " Don't create fold if entire comment or {} pair is on one line.
  if ( thisLine =~ '\%(\%(/\*\*\).*\%(\*/\)\)\|\%({.*}\)\|\%(\[.*\]\)' )
    return '='
  elseif ( thisLine =~ '\%(^\s*/\*\*\s*$\)\|{\|\[\|\(#if\(def\|ndef\)\?\)' )
    return "a1"
  elseif ( thisLine =~ '\%(^\s*\*/\s*$\)\|}\|\]\|\(#endif\)' )
    return "s1"
  endif
  return '='
endfunction
setlocal foldexpr=MyFoldLevel(v:lnum)
setlocal foldmethod=expr
au FileType cpp,c set fdm=syntax
au BufRead,BufNewFile *.py,*.pyw,*.tex,*.txt set fdm=indent
au FileType python,plaintex,text set fdm=indent
" }

" Searching {
" Highlight search matches
set hlsearch

" Ignore case when searching
set ignorecase

" Show search matches while typing
set incsearch

" Regular Expressions set to very magic
nnoremap / /\v
vnoremap / /\v
cnoremap %s %s/\v
cnoremap s/ s/\v
cnoremap \>s/ \>s/\v
nnoremap :g/ :g/\v
nnoremap :g// :g//
" }

" Spaces & Tabs {
" Changes tabulary to spaces
set expandtab

" Tabs only two spaces
set tabstop=2
set shiftwidth=2

au FileType python,perl set shiftwidth=4
au FileType python,perl set tabstop=4
au FileType make set noexpandtab
" }

" Backups {
" Central directory for swap files
set backup
set directory=$HOME/.vim/.backup//
set backupdir=$HOME/.vim/.backup//
set undodir=$HOME/.vim/.backup//
set writebackup
set undofile
" }

" UI Layout {
" Removes useless gui crap
set guioptions-=M
set guioptions-=T
set guioptions-=m
set guioptions-=r
" }

" Vundle {
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'AndrewRadev/linediff.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'elzr/vim-json'
Plugin 'gmarik/Vundle.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-python/python-syntax'
Plugin 'vim-syntastic/syntastic'
Plugin 'wesQ3/vim-windowswap'

call vundle#end()
filetype plugin indent on
" }

" python-syntax {
let g:python_highlight_all = 1
" }

" vim-json {
let g:vim_json_syntax_conceal = 0
" }

" vim-windowswap {
nnoremap <C-y>w :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <C-p>w :call WindowSwap#DoWindowSwap()<CR>
nnoremap <C-w>w :call WindowSwap#EasyWindowSwap()<CR>
" }

" linediff {
noremap \ldt :Linediff<CR>
noremap \ldo :LinediffReset<CR>
" }

" Airline {
" :AirlineTheme solarized
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_spell=1
let g:airline_detect_spelllang=1
" let g:airline_left_sep='>'
let g:airline_left_sep = '▶'
" let g:airline_right_sep='<'
let g:airline_right_sep = '◀'
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_inactive_collapse=1
function! AirlineInit()
  let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
  let g:airline_section_b = airline#section#create_left(['ffenc', 'hunks', '%f'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['%B'])
  let g:airline_section_z = airline#section#create_right(['%l', '%c'])
endfunction
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
let NERDTreeIgnore = ['\.pyc$', '\.hi$', '\.o$', '\.dyn_hi$', '\.dyn_o$', '\.exe$', '\.swp$', '\.bak$', '\.pyc$', '\.class$', '\~$']
let NERDTreeWinSize = 42
let NERDTreeQuitOnOpen = 1
let NERDTreeDirArrows = 0
let NERDTreeDirArrowsExpandable = '+'
let NERDTreeDirArrowsCollapsible = '~'
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenVSplit='v'
" let NERDTreeMapOpenSplit='-'
" let NERDTreeMapOpenVSplit='|'
" }

" Syntastic stuff {
function! s:get_cabal_sandbox()
  if filereadable('cabal.sandbox.config')
    let l:output = system('cat cabal.sandbox.config | grep local-repo')
    let l:dir = matchstr(substitute(l:output, '\n', ' ', 'g'), 'local-repo: \zs\S\+\ze\/packages')
    return '-s ' . l:dir
  else
    return ''
  endif
endfunction

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
let g:syntastic_cpp_checkers = ['cppcheck', 'cpplint']

" let g:syntastic_c_cflags = '-I/usr/include/lib'

let g:syntastic_cpp_include_dirs =
      \ ['../include', 'include', 'includes', 'headers', '/\*\*/inc',
      \ '../../inc', '../inc', 'inc', '/\*\*/export', '../../export',
      \ '../export', 'export', '../../src', '../src', 'src', '../test/bin',
      \ 'test/bin']
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_enable_signs = 1

function! FindConfig(prefix, what, where)
  let cfg = findfile(a:what, escape(a:where, ' ') . ';')
  return cfg !=# '' ? ' ' . a:prefix . ' ' . shellescape(cfg) : ''
endfunction

autocmd FileType c,cpp,objc let b:syntastic_cpp_cpplint_args =
      \ get(g:, 'syntastic_cpp_cpplint_args', '') .
      \ FindConfig('-c', '.h', expand('<afile>:p:h', 1))

autocmd FileType javascript let b:syntastic_javascript_jscs_args =
      \ get(g:, 'syntastic_javascript_jscs_args', '') .
      \ FindConfig('-c', '.jscsrc', expand('<afile>:p:h', 1))
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
  " if gvim else vim
  let g:solarized_contrast="high" " low | normal | high
  let g:solarized_visibility="high" " low | normal | high
  " set background=light
  set background=dark

  " Window Size
  if exists("+columns")
    set columns=90
  endif
  if exists("+lines")
    set lines = 64
  endif
else
  set t_Co=256
  let g:solarized_contrast = "high" " low | normal | high
  let g:solarized_visibility = "high" " low | normal | high
  set background=dark
endif
colorscheme solarized

set colorcolumn=81,82,83
" au FileType python,perl set colorcolumn=121,122,123
au FileType cpp,c set colorcolumn=121,122,123

" Highlights
highlight Black ctermfg=Black guifg=Black
highlight Blue ctermfg=DarkBlue guifg=DarkBlue
highlight Green ctermfg=DarkGreen guifg=DarkGreen
highlight Cyan ctermfg=DarkCyan guifg=DarkCyan
highlight Red ctermfg=DarkRed guifg=DarkRed
highlight Magenta ctermfg=DarkMagenta guifg=DarkMagenta
highlight Brown ctermfg=Brown guifg=Brown
highlight Grey ctermfg=Grey guifg=Grey
highlight DarkGrey ctermfg=DarkGrey guifg=DarkGrey
highlight BrightBlue ctermfg=Blue guifg=Blue
highlight BrightGreen ctermfg=Green guifg=Green
highlight BrightCyan ctermfg=Cyan guifg=Cyan
highlight Orange ctermfg=Red guifg=Red
highlight Violet ctermfg=Magenta guifg=Magenta
highlight Yellow ctermfg=Yellow guifg=Yellow
highlight White ctermfg=White guifg=White

au FileType plaintex,text,log call MultipleMatches()
fu! MultipleMatches()
  let m = matchadd("Cyan", '<[^>]\+>')
  let m = matchadd("Cyan", '([^)]*)')
  let m = matchadd("Orange", '\d\+:\d\+\(:\d\+\.\d\+\)*')
  let m = matchadd("Orange", '\d\+-\d\+-\d\+')
  let m = matchadd("Orange", '0x[0-9a-fA-F]\+')
  let m = matchadd("White", '\w\+\.[a-zA-Z]\+\(:\d\+\)')
  let m = matchadd("Blue", '\w\+=')
  let m = matchadd("Cyan", '"[^\"]\+"')
  let m = matchadd("RED", '\cwarn\w*')
  let m = matchadd("RED", '\cfail\w*')
  let m = matchadd("RED", '\cinfo\w*')
endfu
" }

" Highlighting Errors {
let bit_operations = "*&|"
let bit_operations_after = "|[". bit_operations ."]{1,2}\\w"
let bit_operations_before = "|\\w[". bit_operations ."]{1,2}"

let pattern = "\\s(if|for|while)\\(" " . bit_operations_after . bit_operations_before
au FileType cpp,c let pattern = pattern.bit_operations_after.bit_operations_before
highlight ExtraWhitespace ctermbg=Grey guibg=Grey ctermfg=Black guifg=Black
execute 'match ExtraWhitespace /\v'. pattern .'/'
execute 'autocmd BufWinEnter * match ExtraWhitespace /\v'. pattern .'/'
execute 'autocmd InsertLeave * match ExtraWhitespace /\v'. pattern .'/'
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufWinLeave * call clearmatches()

" Added a new command to remove trailing spaces
" (search and replace / whitespaces / one or more, end of line)
command RemoveSpaces %s/\s\+$/
command AddSpaces %s/ \(if\|for\|while\)(/ \1 (/
" }
