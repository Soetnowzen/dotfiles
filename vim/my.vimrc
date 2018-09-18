set encoding=utf-8
set fileencoding=utf-8
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

let &t_EI = "\<Esc>[1 q"
let &t_SI = "\<Esc>[5 q"

" Auto startups {
augroup Shebang " {
  autocmd!
  autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl># -*- coding: utf-8 -*-\<nl>\"|$
  autocmd BufNewFile *.rb 0put =\"#!/usr/bin/env ruby\<nl># -*- coding: utf-8 -*-\<nl>\"|$
  autocmd BufNewFile *.tex 0put =\"%&plain\<nl>\"|$
  autocmd BufNewFile *.sh 0put =\"#!/bin/bash\"|$
augroup END
"   }

function! s:insert_gates() " {
  let gatename = substitute(toupper(substitute(expand("%:t"), '\C\([A-Z]\)', '_\1','g')), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! Go#endif /* " . gatename . " */"
  normal! k
endfunction " }
augroup c_insert_gates " {
  autocmd!
  autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()
augroup END
"   }
" }

" Vundle {
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'AndrewRadev/linediff.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'elzr/vim-json'
Plugin 'gmarik/Vundle.vim'
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
  set background=light
  " set background=dark

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

set mouse=a

set showcmd

" Delete comment characters when joining lines.
set formatoptions+=j

" Change the map of <leader> from \ to ,
let mapleader=","

" set System clipboard
set clipboard=unnamed

" more auto complete <Ctrl>-P options
set completeopt=menu,longest,preview

set splitbelow
set splitright

" Show auto completion options
set wildchar=<Tab>
set wildmenu
set wildmode=list:longest,full

"   line break options {
set linebreak
set showbreak=\ \ 
augroup showbreaker " {
  autocmd!
  autocmd FileType python,perl set showbreak=\ \ \ \ 
augroup END
"     }
set cindent
set cpoptions+=n
set cinoptions+=(0
set cinoptions+=u0
set cinoptions+=U0
set breakindent
set breakat+=>
"   }

set switchbuf+=useopen
set switchbuf+=usetab
set switchbuf+=split

"   :e ignores files {
set wildignore+=*.bak
set wildignore+=*.class
set wildignore+=*.exe
set wildignore+=*.hi
set wildignore+=*.o
set wildignore+=*.pyc
set wildignore+=*.swp
set wildignore+=tags
"   }

set diffopt+=iwhite
augroup set_filetype " {
  autocmd!
  autocmd BufRead,BufNewFile *.json set filetype=json
  autocmd BufRead,BufNewFile *.log set filetype=log
  autocmd BufRead,BufNewFile *.txt set filetype=text
augroup END
"   }
" }

" Toggle Comments {
let s:comment_map = {
      \ "ahk": ';',
      \ "automake": '#',
      \ "bash_profile": '#',
      \ "bashrc": '#',
      \ "bat": 'REM',
      \ "c": '\/\/',
      \ "cfg": '#',
      \ "conf": '#',
      \ "cpp": '\/\/',
      \ "csh": '#',
      \ "desktop": '#',
      \ "eml": '>',
      \ "erlang": '%',
      \ "fstab": '#',
      \ "gdb": '#',
      \ "gitconfig": '#',
      \ "go": '\/\/',
      \ "haskell": '--',
      \ "java": '\/\/',
      \ "javascript": '\/\/',
      \ "lua": '--',
      \ "mail": '>',
      \ "make": '#',
      \ "php": '\/\/',
      \ "profile": '#',
      \ "proto": '\/\/',
      \ "python": '#',
      \ "ruby": '#',
      \ "rust": '\/\/',
      \ "scala": '\/\/',
      \ "sh": '#',
      \ "spec": '#',
      \ "tcsh": '#',
      \ "tex": '%',
      \ "text": '#',
      \ "tmux": "#",
      \ "vim": '"',
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

let s:block_comment_map = {
      \ "xml": ['<!--', '-->'],
      \ }

function! ToggleBlockComment()
  if has_key(s:block_comment_map, &filetype)
    let comment_character = s:comment_map[&filetype]
    execute "normal! c" . comment_character[0] . "\<CR>" . comment_character[1] . "\<Esc>\<Up>p"
  endif
endfunction

nnoremap <Leader><Space> :call ToggleComment()<CR>
vnoremap <C-m> :call ToggleComment()<CR>
nnoremap <C-m> :call ToggleComment()<CR>
" vnoremap <Leader>m c(s:block_comment_map[&filetype][0])<CR>(s:block_comment_map[&filetype][1])<Esc><Up>p
vnoremap <Leader>m :call ToggleBlockComment()<CR>
" }

" Mapping {
"   mswim.vim {
" unmaps Ctrl + Y to be able to write the same character as above while mswim.vim is imported
iunmap <C-Y>

" unmaps <Ctrl> + Z to be able to suspend while mswim.vim is imported
unmap <C-Z>

" unmaps <Ctrl> + a to be able to increment numbers while mswin.vim is imported
nunmap <C-a>

" Avoid mswin.vim making Ctrl-v act as paste
noremap <C-v> <C-v>
"   }

noremap <LeftRelease> "+y<LeftRelease>
set guioptions+=a

" Vertically split the screen into two windows with scrollbind set, <C-W>o to quit
noremap <Leader>ac :execute AddColumn()<CR>
function! AddColumn()
  " {
  execute "norm \<C-u>"
  let @z=&so
  set noscb so=0
  botright vsplit
  execute "norm \<PageDown>"
  setlocal scrollbind
  wincmd p
  setlocal scrollbind
  let &so=@z
  " }
endfunction

"   Normal mode remap {
"     Navigate wrapped lines {
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
"     }
nnoremap Q gqap
" move to beginning/end of line
nnoremap B ^
nnoremap E $
nnoremap <Leader>p :put "<CR>
nnoremap <Leader>P :put! "<CR>
nnoremap p ]p
nnoremap <C-p> p

" normal mode remap case switch
nnoremap § ~

nnoremap <Tab> >>_
nnoremap <S-Tab> <<_

" Convert snake case to camel case
nnoremap _ f_x~
" Convert camel case to snake case
nnoremap + /\C[A-Z]<CR>i_<Esc><Right>~:noh<CR>

" nnoremap <Space> :noh<CR>
nnoremap <expr> <Space> foldlevel('.') ? 'za' : ":noh\<CR>"

"     The glorious & dear vim leader declarations {
" nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :e<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>j :
nnoremap <Leader>i <C-]>
nnoremap <Leader>v :tabe ~/.vimrc<CR>
nnoremap <Leader>sp [s
nnoremap <Leader>sn ]s
nnoremap <Leader>cp [c
nnoremap <Leader>cn ]c
"     }
"   }

map Y y$

"   Command-line mode remaps {
cnoremap jj <Esc>
" cnoremap ' ''<Left>
" cnoremap '' ''
" cnoremap " ""<Left>
" cnoremap "" ""
" cnoremap { {}<Left>
" }
" cnoremap {} {}
" cnoremap < <><Left>
" cnoremap <<Space> <<Space>
" cnoremap <> <>
" cnoremap [ []<Left>
" cnoremap [] []
" cnoremap ( ()<Left>
" cnoremap () ()
"   }

"   Visual mode remaps {
" visual mode remap case switch
vnoremap § ~

vnoremap Q gq
vnoremap B ^
vnoremap E $

vnoremap <Leader>u gU
vnoremap <Leader>l gu
"   }

"   Insertion mode remaps {
"     insert Leader mapping {
inoremap <Leader>f <C-r>=expand("%:t:r")<CR>
"     }
inoremap <S-Tab> <C-D>

inoremap </ </<C-X><C-O>

" Search for next '#'
" inoremap <Tab> <C-O>f#s
" inoremap <CR> <C-O>"tpf#s
inoremap :w<CR> <Esc>:w<CR>a
inoremap :wq<CR> <Esc>:wq<CR>
inoremap jj <Esc>
inoremap jk <Esc>
inoremap JJ <Esc>o
inoremap { {}<Left>
" }
inoremap {- {--}<Left><Left>
" {{
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap < <><Left>
inoremap <<Space> <<Space>
inoremap << <
inoremap <<<Space> <<<Space>
inoremap =<<Space> =<<Space>
inoremap <expr> >  strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
inoremap [ []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap ( ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> ` strpart(getline('.'), col('.')-1, 1) == "\`" ? "\<Right>" : "\`\`\<Left>"
inoremap <expr> <Space> strpart(getline('.'), col('.')-1, 1) == " " ? "\<Right>" : " "
inoremap /* /**/<Left><Left>
inoremap /*<BS> <NOP>
inoremap /*<BS><BS> <NOP>
inoremap """ """"""<Left><Left><Left>
inoremap ''' ''''''<Left><Left><Left>
inoremap ,, <End>,
inoremap ;; <End>;
inoremap ;;<CR> ;;<CR>
inoremap <expr> ,  strpart(getline('.'), col('.')-1, 1) == "," ? "\<Right>" : ","
augroup c_insert_mapping " {
  autocmd!
  autocmd FileType c,cpp,sh inoremap #ifdef<Space> #ifdef<CR>#endif<Up><End><Space>
  autocmd FileType c,cpp,sh inoremap #ifndef<Space> #ifndef<CR>#endif<Up><End><Space>
augroup END
"     }
augroup make_insert_mapping " {
  autocmd!
  autocmd FileType make,automake inoremap ifdef<Space> ifdef<CR>endif<Up><End><Space>
  autocmd FileType make,automake inoremap ifndef<Space> ifndef<CR>endif<Up><End><Space>
  autocmd FileType make,automake,spec inoremap ifeq<Space> ifeq<CR>endif<Up><End><Space>(,)<Left><Left>
  autocmd FileType make,automake,spec inoremap ifneq<Space> ifneq<CR>endif<Up><End><Space>(,)<Left><Left>
  autocmd FileType sh,make,automake inoremap if<Space> if<CR>fi<Up><End><Space>[]; then<Left><Left><Left><Left><Left><Left><Left>
  autocmd FileType sh,make,automake inoremap elif<Space> elif<Space>[]; then<Left><Left><Left><Left><Left><Left><Left>
augroup END
"     }
augroup sh_insert_mapping " {
  autocmd!
  autocmd FileType sh inoremap case<Space> case<Space><CR>;;<CR><BS><BS>esac<Up><Up><End><Space>in<Left><Left><Left>
  autocmd FileType sh inoremap while<Space> while<CR>done<Up><End><Space>[]; do<Left><Left><Left><Left><Left>
  autocmd FileType sh inoremap for<Space> for<CR>done<Up><End><Space>; do<Left><Left><Left><Left>
augroup END
"     }
augroup vim_insert_mapping " {
  autocmd!
  autocmd FileType vim inoremap if<Space> if<CR>endif<Up><End><Space>
  autocmd FileType vim inoremap elseif<Space> elseif<Space>
  autocmd FileType vim inoremap augroup<Space> augroup<CR><Tab>autocmd!<CR>augroup<Space>END<Up><Up><End><Space>
augroup END
"     }
augroup tcsh_insert_mapping " {
  autocmd!
  autocmd FileType tcsh inoremap if<Space> if<CR>endif<Up><End><Space>()<Space>then<Left><Left><Left><Left><Left><Left>
augroup END
"     }
augroup gdb_insert_mapping " {
  autocmd!
  autocmd FileType gdb inoremap define<Space> define<CR>end<Up><End><Space>
  autocmd FileType gdb inoremap document<Space> document<CR>end<Up><End><Space>
augroup END
"     }
augroup markdown_insert_mapping " {
  autocmd!
  autocmd FileType markdown inoremap & &;<Left>
  autocmd FileType markdown inoremap <expr> ;  strpart(getline('.'), col('.')-1, 1) == ";" ? "\<Right>" : ";"
augroup END
"     }
augroup python_insert_mapping " {
  autocmd!
  autocmd FileType python inoremap if<Space> if<Space>:<Left>
  autocmd FileType python inoremap elif<Space> elif<Space>:<Left>
  autocmd FileType python inoremap for<Space> for<Space>:<Left>
  autocmd FileType python inoremap while<Space> while<Space>:<Left>
  autocmd FileType python inoremap def<Space> def<Space>(self):<Left><Left><Left><Left><Left><Left><Left>
augroup END
"     }
augroup xml_insert_mapping " {
  autocmd!
  autocmd FileType xml inoremap <! <!----><Left><Left><Left>
  autocmd FileType xml inoremap <expr> - strpart(getline('.'), col('.')-1, 1) == "-" ? "\<Right>" : "-"
augroup END
"     }

let pairing_characters = ["[]", "{}", "''", "\"\"", "()", "**", "\/\/", "<>", "  ", "--", "``"]
inoremap <expr> <BS>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<Right>\<BS>\<BS>" : "\<BS>"
inoremap <expr> <CR>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<CR>\<Esc>O" : "\<CR>"
inoremap <expr> <Space>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<Space>\<Space>\<Left>" : "\<Space>"
"   }

"   Operator-Pending Mappings {
onoremap p i(
onoremap in( :<C-u>normal! f(vi(<CR>
onoremap il( :<C-u>normal! F)vi(<CR>
"   }
" }

" Spelling {
iabbrev anf and
iabbrev adn and
iabbrev ans and
iabbrev teh the
iabbrev thre there

set spell spelllang=en_us
set spellfile=$HOME/.vim/spell/en.utf-8.add
" }

augroup tag_completion " {
  autocmd!
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
augroup END
" }

" Folding {
set foldcolumn=1
" highlight clear Folded
highlight Folded cterm=Bold gui=Bold

function! MyFoldLevel( lineNumber )
  " {
  let thisLine = getline( a:lineNumber )
  " Don't create fold if entire comment or {} pair is on one line.
  if (thisLine =~ '\%(/\*.*\*/\)')
    return '='
  elseif ( thisLine =~ '/\*')
    return "a1"
  elseif ( thisLine =~ '\*/')
    return "s1"
  elseif ( thisLine =~ '\%({.*}\)')
    return '='
  elseif ( thisLine =~ '{')
    return "a1"
  elseif (thisLine =~ '}')
    return "s1"
  elseif ( thisLine =~ '\%(\[.*\]\)' )
    return '='
  elseif ( thisLine =~ '\[')
    return "a1"
  elseif (thisLine =~ '\]')
    return "s1"
  elseif ( thisLine =~ '\(#if\(def\|ndef\)\?\)' )
    return "a1"
  elseif (thisLine =~ '\(#endif\)' )
    return "s1"
  endif
  return '='
  " }
endfunction

setlocal foldexpr=MyFoldLevel(v:lnum)
setlocal foldmethod=expr
augroup syntax_folding " {
  autocmd!
  autocmd FileType cpp,c,java set foldmethod=syntax
  autocmd FileType vim,xml set foldmethod=marker
  autocmd FileType vim set foldmarker={,}
  autocmd FileType xml set foldmarker=<!--,-->
  autocmd FileType python,plaintex,text,gdb,make,automake,gitconfig set foldmethod=indent
  autocmd FileType java set foldenable
  " autocmd FileType java syntax clear javaBraces
  " autocmd FileType java syntax clear javaDocComment
  " autocmd FileType java syntax region foldBraces start=/{/ end=/}/ transparent fold keepend extend
  autocmd FileType java syntax region foldJavadoc start=+/\*+ end=+\*/+ transparent fold keepend
  autocmd FileType java syntax region foldBrackets start="\[" end="]" transparent fold keepend
  autocmd FileType java syntax region foldParenthesis start="(" end=")" transparent fold keepend
  autocmd FileType java set foldlevel=0
  autocmd FileType java set foldnestmax=10
  autocmd FileType cpp,c syntax region foldIfNotDef start="#ifndef" end="#endif" transparent fold keepend
  autocmd FileType cpp,c syntax region foldIfDef start="#ifdef" end="#endif" transparent fold keepend
augroup END
"   }

set foldtext=MyFoldText()
function MyFoldText()
  " {
  let line = getline(v:foldstart)
  let tabStop = repeat(' ', &tabstop)
  let line = substitute(line, '\t', tabStop, 'g')
  let number_of_lines = v:foldend - v:foldstart + 1
  return  line . ' ' . v:folddashes . ' +' . number_of_lines . ' ☰ '
  " }
endfunction

set fillchars=vert:\|,fold:-
" }

" Searching {
" Highlight search matches
set hlsearch

" Ignore case when searching
set ignorecase

" Show search matches while typing
set incsearch

"   Regular Expressions set to very magic {
nnoremap / /\v
vnoremap / /\v
cnoremap %s %s/\v
cnoremap s/ s/\v
cnoremap \>s/ \>s/\v
nnoremap :g/ :g/\v
nnoremap :g// :g//
"   }
" }

" Spaces & Tabs {

"   Show hidden characters with given characters {
" highlight NonText ctermfg=Magenta guifg=Magenta
highlight clear SpecialKey
" highlight SpecialKey ctermfg=Magenta guifg=Magenta
highlight SpecialKey ctermfg=Green guifg=Green
set list
set listchars=tab:>\ 
set listchars+=trail:-
set listchars+=conceal:C  " conceallevel is set to 1
set listchars+=nbsp:%  " Non-breakable space
set listchars+=extends:>,precedes:<
"   }

set smartindent

" Present file labels in a easy to read way
set guitablabel=\[%N\]\ %t\ %M

" Changes tabularly to spaces
set expandtab

" Tabs only two spaces
set tabstop=2
set shiftwidth=2

augroup indentaion_handling " {
  autocmd!
  autocmd FileType python,perl,xml,make,automake,gitconfig,text set tabstop=4
  autocmd FileType python,perl,xml,make,automake,gitconfig,text set shiftwidth=4
  autocmd FileType make,automake,gitconfig,text set noexpandtab
augroup END
"   }
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

" GUI Layout {
" Removes useless GUI crap
set guioptions-=M
set guioptions-=T
set guioptions-=m
set guioptions-=r
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
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
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
  " {
  let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
  let g:airline_section_b = airline#section#create_left(['ffenc', 'hunks', '%f'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['%B'])
  let g:airline_section_z = airline#section#create_right(['%l', '%c'])
  " }
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
let NERDTreeIgnore =
      \ ['\.pyc$', '\.hi$', '\.o$', '\.dyn_hi$', '\.dyn_o$', '\.exe$',
      \ '\.swp$', '\.bak$', '\.pyc$', '\.class$', '\~$']
let NERDTreeWinSize = 42
let NERDTreeQuitOnOpen = 1
let NERDTreeDirArrows = 0
" let NERDTreeDirArrowsExpandable = '+'
" let NERDTreeDirArrowsCollapsible = '~'
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
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++ -D_FORTIFY_SOURCE=1'
" let g:syntastic_cpp_compiler = 'gcc'
" let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++ -D_FORTIFY_SOURCE=1'
let g:syntastic_enable_signs = 1

function! FindConfig(prefix, what, where)
  let cfg = findfile(a:what, escape(a:where, ' ') . ';')
  return cfg !=# '' ? ' ' . a:prefix . ' ' . shellescape(cfg) : ''
endfunction

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
" nnoremap <Leader>j <Plug>GitGutterNextHunk
" nnoremap <Leader>k <Plug>GitGutterPrevHunk
" nnoremap <Leader>ha <Plug>GitGutterStageHunk
" nnoremap <Leader>hr <Plug>GitGutterUndoHunk
" nnoremap <Leader>hv <Plug>GitGutterPreviewHunk

if exists('&signcolumn') " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" let g:gitgutter_sign_added = 'xx'
" let g:gitgutter_sign_modified = 'yy'
" let g:gitgutter_sign_removed = 'zz'
" let g:gitgutter_sign_removed_first_line = '^^'
" let g:gitgutter_sign_modified_removed = 'ww'

let g:gitgutter_diff_args = '-w'
" }

" Highlighting Errors {
let bit_operations = "*&|"
let bit_operations_after = "|[". bit_operations ."]{1,2}\\w"
let bit_operations_before = "|\\w[". bit_operations ."]{1,2}"

let pattern = "\\s(if|for|while)\\(" " . bit_operations_after . bit_operations_before
autocmd FileType cpp,c let pattern = pattern.bit_operations_after.bit_operations_before
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
