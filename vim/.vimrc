set encoding=utf-8
set nocompatible
filetype off
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

" if &term =~ "xterm\\|urxvt"
"   let &t_SI .= "\<Esc>[5 q"
"   let &t_EI .= "\<Esc>[1 q"
" endif
let &t_SI .= "\<Esc>[5 q"
let &t_EI .= "\<Esc>[1 q"

" vimdiff opens in vertical mode now
" set diffopt=vertical

" Sets row numbers
set number

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

" unmap ctrl + Y
iunmap <C-Y>

" if has('win32')
  " Avoid mswin.vim making Ctrl-v ac as paste
noremap <C-v> <C-v>
" endif

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

" normal mode remap case switch
nnoremap § ~

" visual mode remap case switch
vnoremap § ~

nnoremap <space> :noh<cr>

" Insertion mode remaps
inoremap :w<cr> <Esc>:w<cr>a
inoremap :wq<cr> <Esc>:wq<cr>
inoremap jj <Esc>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {  " }}
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap < <><Left>
inoremap <<space> <<space>
inoremap << <
inoremap <<<space> <<<space>
inoremap <expr> >  strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
inoremap [ []<Left>
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
inoremap <Leader>/* /*
inoremap """<CR> """<CR>"""<Esc>O
inoremap '''<CR> '''<CR>'''<Esc>O

let pairing_characters = ["[]", "{}", "''", "\"\"", "()", "**", "\/\/", "<>", "  "]
inoremap <expr> <BS>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<Right>\<BS>\<BS>" : "\<BS>"

" Cursor marking
set cursorline
set cursorcolumn

" Set fold method to be indentation instead of manual
" set foldmethod=indent
" set foldnestmax=10
" set nofoldenable
" set foldlevel=1
" set fdm=syntax
" set foldlevelstart=1

" let javaScript_fold=1     " JavaScript
" let perl_fold=1           " Perl
" let php_folding=1         " PHP
" let r_syntax_folding=1    " R
" let ruby_fold=1           " Ruby
" let sh_fold_enabled=1     " sh
" let vimsyn_folding='af'   " Vim script
" let xml_syntax_folding=1  " XML
function! MyFoldLevel( lineNumber )
  let thisLine = getline( a:lineNumber )
  " Don't create fold if entire comment or {} pair is on one line.
  if ( thisLine =~ '\%(\%(/\*\*\).*\%(\*/\)\)\|\%({.*}\)' )
    return '='
  elseif ( thisLine =~ '\%(^\s*/\*\*\s*$\)\|{' )
    return "a1"
  elseif ( thisLine =~ '\%(^\s*\*/\s*$\)\|}' )
    return "s1"
  endif
  return '='
endfunction
setlocal foldexpr=MyFoldLevel(v:lnum)
setlocal foldmethod=expr
" au BufRead,BufNewFile *.cpp,*.h,*.cc,*.c,*.hpp set fdm=syntax
au FileType cpp,c set fdm=syntax
au BufRead,BufNewFile *.py,*.pyw,*.tex,*.txt set fdm=indent
au FileType python,plaintex set fdm=indent
" set fdm=marker
" set fmr={,}
" set fdm=syntax
" syn region csFold start="{" end="}" transparent fold

" Regular Expressions set to very magic
nnoremap / /\v\c
vnoremap / /\v\c
cnoremap %s %s/\v
cnoremap s/ s/\v
cnoremap \>s/ \>s/\v
nnoremap :g/ :g/\v
nnoremap :g// :g//

" Leave a few lines when scrolling
set scrolloff=3

" Changes tabulary to spaces
set expandtab

" Tabs only two spaces
set tabstop=2
set shiftwidth=2

" au BufRead,BufNewFile *.py,*.pyw,*.pl,*.sh set shiftwidth=4
" au BufRead,BufNewFile *.py,*.pyw,*.pl,*.sh set tabstop=4
au FileType python,perl,sh set shiftwidth=4
au FileType python,perl,sh set tabstop=4
au BufRead,BufNewFile *.tex,*.txt set spell spelllang=en_us
au FileType plaintex set spell spelllang=en_us
" au BufRead,BufNewFile Makefile* set noexpandtab
au FileType make set noexpandtab

" Central directory for swap files
set backup
set directory=$HOME/.vim/.backup//
set backupdir=$HOME/.vim/.backup//
set undodir=$HOME/.vim/.backup//
set writebackup
set undofile

" Removes useless gui crap
set guioptions-=M
set guioptions-=T
set guioptions-=m
set guioptions-=r

set switchbuf +=useopen
set switchbuf +=usetab
set switchbuf +=split

" Doesn't save swp-files after each session
" set nobackup
" set noundofile

" :e ignores files
"set wildignore=*.o, *.exe, *.hi, *.swp

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugin 'rhysd/vim-clang-format'
Plugin 'AndrewRadev/linediff.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
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

let g:python_highlight_all = 1

" vim-windowswap
nnoremap <C-y>w :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <C-p>w :call WindowSwap#DoWindowSwap()<CR>
nnoremap <C-w>w :call WindowSwap#EasyWindowSwap()<CR>

" linediff
noremap \ldt :Linediff<CR>
noremap \ldo :LinediffReset<CR>

" vim-clang-format
" your favorite style options
" let g:clang_format#style_options = {
      " \ "AccessModifierOffset" : -4,
      " \ "AllowShortIfStatementsOnASingleLine" : "false",
      " \ "AlwaysBreakTemplateDeclarations" : "true",
      " \ "Standard" : "C++11",
      " \ "TabWidth" : 2,
      " \ "AlignAfterOpenBracket" : "Align",
      " \ "AlignOperands" : "true",
      " \ "AllowAllParametersOfDeclarationOnNextLine" : "false",
      " \ "AllowShortCaseLabelsOnASingleLine" : "false",
      " \ "AllowShortFunctionsOnASingleLine" : "None",
      " \ "AllowShortLoopsOnASingleLine" : "false",
      " \ "AlwaysBreakBeforeMultilineStrings" : "false",
      " \ "BinPackArguments" : "false",
      " \ "BinPackParameters" : "false",
      " \ "AfterClass" : "true",
      " \ "AfterControlStatement" : "true",
      " \ "AfterEnum" : "true",
      " \ "AfterFunction" : "true",
      " \ "AfterNamespace" : "true",
      " \ "AfterStruct" : "true",
      " \ "AfterUnion" : "true",
      " \ "AfterExternBlock" : "true",
      " \ "BeforeCatch" : "true",
      " \ "BeforeElse" : "true",
      " \ "SplitEmptyFunction" : "true",
      " \ "SplitEmptyRecord" : "true",
      " \ "SplitEmptyNamespace" : "true",
      " \ "BreakBeforeBinaryOperators" : "NonAssignment",
      " \ "BreakConstructorInitializers" : "AfterColon",
      " \ "BreakStringLiterals" : "true",
      " \ "ColumnLimit" : 150,
      " \ "CompactNamespaces" : "false",
      " \ "ConstructorInitializerAllOnOneLineOrOnePerLine" : "false",
      " \ "ContinuationIndentWidth" : 2,
      " \ "FixNamespaceComments" : "false",
      " \ "IndentCaseLabels" : "true",
      " \ "IndentPPDirectives" : "None",
      " \ "IndentWidth" : 2,
      " \ "IndentWrappedFunctionNames" : "true",
      " \ "KeepEmptyLinesAtTheStartOfBlocks" : "false",
      " \ "MaxEmptyLinesToKeep" : 1,
      " \ "NamespaceIndentation" : "All",
      " \ "DerivePointerAlignment" : "true",
      " \ "PointerAlignment" : "Middle",
      " \ "SortIncludes" : "true",
      " \ "SortUsingDeclarations" : "true",
      " \ "SpaceAfterCStyleCast" : "false",
      " \ "SpaceAfterTemplateKeyword" : "false",
      " \ "SpaceBeforeAssignmentOperators" : "true",
      " \ "SpaceBeforeParens" : "ControlStatements",
      " \ "SpaceInEmptyParentheses" : "false",
      " \ "SpacesBeforeTrailingComments" : 1,
      " \ "SpacesInAngles" : "false",
      " \ "SpacesInCStyleCastParentheses" : "false",
      " \ "SpacesInContainerLiterals" : "false",
      " \ "SpacesInParentheses" : "false",
      " \ "SpacesInSquareBrackets" : "false",
      " \ "UseTab" : "Never",
      " \ "BreakBeforeBraces" : "GNU"}
" SBPO_Never | SBPO_ControlStatements | SBPO_Always

" map to = in C++ code
" augroup ClangFormatSettings
  " autocmd!
  " autocmd FileType c,cpp,objc nnoremap = :<C-u>ClangFormat<CR>
  " autocmd FileType c,cpp,objc vnoremap = :ClangFormat<CR>
  " if you install vim-operator-user
  " autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" augroup END

" Arline
" :AirlineTheme solarized
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_spell=1
let g:airline_detect_spelllang=1
function! AirlineInit()
  let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
  let g:airline_section_b = airline#section#create_left(['ffenc', 'hunks', '%f'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['%B'])
  let g:airline_section_z = airline#section#create_right(['%l', '%c'])
endfunction
autocmd VimEnter * call AirlineInit()

" vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
" let g:cpp_experimental_simple_template_highlight = 1  " Or
let g:cpp_experimental_template_highlight = 1
let g:cpp_no_function_highlight = 1

" Map Ctrl-n to open the NERDTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.hi$', '\.o$', '\.dyn_hi$', '\.dyn_o$']
let NERDTreeWinSize = 42
let NERDTreeQuitOnOpen = 1
let NERDTreeDirArrows = 0
let NERDTreeDirArrowsExpandable = '+'
let NERDTreeDirArrowsCollapsible = '~'
" let NERDTreeMapOpenSplit='-'
" let NERDTreeMapOpenVSplit='|'

" Syntastic stuff
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
" let g:syntastic_<filetype>_checkers = ['checker-name>']
" let g:syntastic_debug = 3
" let g:syntastic_debug = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_enable_signs = 1
let g:syntastic_haskell_ghc_mod_args = s:get_cabal_sandbox()

let g:syntastic_python_checkers = ['python', 'flake8']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
" let g:syntastic_cpp_checkers = ['clang_cpp', 'gcc']
let g:syntastic_cpp_checkers = ['cppcheck', 'cpplint']

" let g:syntastic_c_cflags = '-I/usr/include/lib'

let g:syntastic_cpp_include_dirs = ['../include', 'include', 'includes', 'headers', '/\*\*/inc', '../../inc', '../inc', 'inc', '/\*\*/export', '../../export', '../export', 'export', '../../src', '../src', 'src', '../test/bin', 'test/bin']
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_enable_signs = 1
let g:syntastic_quiet_messages = {'level': 'warnings'}

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

set wildchar=<Tab> wildmenu wildmode=full

set splitbelow
set splitright

" Sets colors based on a dark background
" if gvim else vim
syntax enable
let g:solarized_bold=1 " 0 | 1
let g:solarized_hitrail=1 " 0 | 1
let g:solarized_italic=1 " 0 | 1
let g:solarized_termcolors=16 " 16 | 256
let g:solarized_termtrans=1 " 0 | 1
let g:solarized_underline=1 " 0 | 1
if has('gui_running')
  let g:solarized_contrast="high" " low | normal | high
  let g:solarized_visibility="high" " low | normal | high
  " set background=light
  set background=dark

  " set guifont
  " set guifont=consolas:h8:w4

  " Window Size
  if exists("+columns")
    set columns=90
  endif
  if exists("+lines")
    set lines = 64
  endif
else
  set t_Co=256
  " Perhaps check if windows or unix is running?
  let g:solarized_contrast = "high" " low | normal | high
  let g:solarized_visibility = "high" " low | normal | high
  set background=dark
endif
colorscheme solarized

" Creates a Bobo for marking error spaces
" highlight Bobo guifg=Magenta ctermfg=Magenta
" highlight ColorColumn guifg=Magenta ctermfg=Magenta
" highlight trail guifg=Magenta ctermfg=Magenta

" Error tokens after 80 tokens
" let &colorcolumn=join(range(81,999),",")
set colorcolumn=81,82,83
" au BufRead,BufNewFile *.py,*.pyw,*.pl set colorcolumn=121,122,123
au FileType python,perl set colorcolumn=121,122,123
" au BufRead,BufNewFile *.cpp,*.h,*.cc,*.c,*.hpp set colorcolumn=161,162,163
au FileType cpp,c set colorcolumn=121,122,123

au BufRead,BufNewFile *.log set filetype=log

" Highlight trailing spaces
" augroup trailing
  " au!
  " au InsertEnter * :match none /\s\+$/
  " au InsertLeave * :match trail /\s\+$/
" augroup END

" set laststatus = 2
" set statusline =
" set statusline +=%1*\ %n\ %*            " buffer number
" set statusline +=%5*%{&ff}%*            " file format
" set statusline +=%3*%y%*                " file type
" set statusline +=%4*\ %<%F%*            " full path
" set statusline +=%2*%m%*                " modified flag

" set statusline +=%#warningmsg#
" set statusline +=%{SyntasticStatuslineFlag()}
" set statusline +=%*

" set statusline +=%1*%=%5l%*             " current line
" set statusline +=%2*/%L%*               " total lines
" set statusline +=%1*%4v\ %*             " virtual column number
" set statusline +=%2*0x%04B\ %*          " character under cursor

" set statusline=
" set statusline +="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"

" highlight StatusLine ctermbg=Blue ctermfg=Yellow guibg=DarkGrey guifg=White
" highlight StatusLineNC ctermbg=Yellow ctermfg=Blue guibg=White guifg=DarkGray
" hi User1 guifg=#eea040 guibg=#222222
" hi User2 guifg=#dd3333 guibg=#222222
" hi User3 guifg=#ff66ff guibg=#222222
" hi User4 guifg=#a0ee40 guibg=#222222
" hi User5 guifg=#eeee40 guibg=#222222

" let bit_operations="\\/\\*\\-\\+\\&\\%\\<\\>\\=\\|"
let bit_operations = "*&|"
let bit_operations_after = "|[". bit_operations ."]{1,2}\\w"
let bit_operations_before = "|\\w[". bit_operations ."]{1,2}"
" let bit_operations_after = "|[^\"].*[". bit_operations ."]{1,2}\\w.*[^\"]"
" let bit_operations_before = "|[^\"].*\\w[". bit_operations ."]{1,2}.*[^\"]"

let pattern = "\\t|\\s+$|\\s(if|for|while)\\(" " . bit_operations_after . bit_operations_before
" au BufRead,BufNewFile *.cpp,*.h,*.cc,*.c,*.hpp let pattern = pattern.bit_operations_after.bit_operations_before
au FileType cpp,c let pattern = pattern.bit_operations_after.bit_operations_before
highlight ExtraWhitespace ctermbg=Grey guibg=Grey ctermfg=Black guifg=Black
execute 'match ExtraWhitespace /\v'. pattern .'/'
execute 'autocmd BufWinEnter * match ExtraWhitespace /\v'. pattern .'/'
execute 'autocmd InsertLeave * match ExtraWhitespace /\v'. pattern .'/'
" match ExtraWhitespace /\s\+$/
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Show search matches while typing
set incsearch

" Show autocompletion options
set wildmenu
set wildmode=list:longest,full

" Search for two something seperated by a whitespace & swap + place '='
" inbetween.
" s/\(.\+\)\s\+\(.\+\)/\2 = \1/g

" Added a new command to remove trailing spaces
" (search and replace / whitespaces / one or more, end of line)
command RemoveSpaces %s/\s\+$/
" command AddSpaces %smagic/(if|for|while)\(/\1 \(/
command AddSpaces %s/ \(if\|for\|while\)(/ \1 (/
" command AfterSpaces %s/\([*+&|]\{1,2\}\)\(\w\)/\1 \2/
" command BeforeSpaces %s/\(\w\)\([*&|]\{1,2\}\)/\1 \2/
