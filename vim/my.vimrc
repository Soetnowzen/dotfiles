set encoding=utf-8
set fileencoding=utf-8
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

runtime custom/vundle.vim
runtime custom/toggle_comments.vim
runtime custom/folding.vim

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
  normal! ko
endfunction " }
augroup c_insert_gates " {
  autocmd!
  autocmd BufNewFile *.{h,hpp,hh} call <SID>insert_gates()
augroup END
"   }
" }

" Misc {
" Sets show row numbers
set number

set tags+=/

" Cursor marking
set cursorline
set cursorcolumn

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

" highlight strings inside C comments
let c_comment_strings=1

"   Text Rendering Options {
set linebreak
set showbreak=\ \ 
"
" Leave a few lines when scrolling
set scrolloff=5
set sidescrolloff=5

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
set showtabline=2

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
  autocmd BufRead,BufNewFile log.* set filetype=log
  autocmd BufRead,BufNewFile *.txt set filetype=text
  autocmd BufRead,BufNewFile *.bb set filetype=sh
augroup END
"   }

set textwidth=0

" Set g flag for search and replace
set gdefault
set hidden

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
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
function! AddColumn() " {
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
nnoremap <C-Space> :noh\<CR>
nnoremap <Leader><CR> :noh\<CR>
" }

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
nnoremap <Leader>c /\v[<=>]{4,}<CR>

" Select block
nnoremap <Leader>b {<S-V>}k
"     }
"   }

nnoremap Y y$

"   Command-line mode remaps {
cnoremap jj <Esc>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-w> <C-Right>
cnoremap <C-b> <C-Left>
"   }

"   Visual mode remaps {
vnoremap " c"<C-r>""<Esc>''l
vnoremap ' c'<C-r>"'<Esc>''l
vnoremap ( c(<C-r>")<Esc>''l
vnoremap [ c[<C-r>"]<Esc>''l
vnoremap { c{<C-r>"}<Esc>''l
" }

vnoremap <F2> d:execute 'normal i' . join(sort(split(getreg('"'))), ' ')<CR>

" visual mode remap case switch
vnoremap § ~

vnoremap Q gq
vnoremap B ^
vnoremap E $

vnoremap <Leader>u gU
vnoremap <Leader>l gu

" Yank to clipboard
nnoremap <Leader><Leader>y "+y
vnoremap <Leader><Leader>y "+y

" Paste from clipboard
nnoremap <Leader><Leader>p "+p
vnoremap <Leader><Leader>p "+p"
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
" }
inoremap < <><Left>
inoremap <<Space> <<Space>
inoremap <<<Space> <<<Space>
inoremap =<<Space> =<<Space>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap /* /**/<Left><Left>
inoremap /** /***/<Left><Left>
inoremap """ """"""<Left><Left><Left>
inoremap ''' ''''''<Left><Left><Left>
inoremap ,, <End>,
inoremap ;; <End>;
inoremap ;;<CR> ;;<CR>
inoremap ;<CR> <End>;<CR>
inoremap .<CR> <End>.<CR>
inoremap :<CR> <End>:<CR>

function! s:ParingUp(char) " {
  let line = getline('.')
  let column = col('.')
  return strpart(line, column-1, 1) == a:char ?
        \ "\<Right>" :
        \ a:char . a:char . "\<Left>"
endfunction " }

inoremap <expr> " <sid>ParingUp("\"")
inoremap <expr> ' <sid>ParingUp("\'")
inoremap <expr> ` <sid>ParingUp("\`")

function! s:HandlingEndingPair(char) " {
  let line = getline('.')
  let column = col('.')
  return strpart(line, column-1, 1) == a:char ?
        \ "\<Right>" :
        \ a:char
endfunction " }

" {{
inoremap <expr> } <sid>HandlingEndingPair('}')
inoremap <expr> ) <sid>HandlingEndingPair(')')
inoremap <expr> * <sid>HandlingEndingPair('*')
inoremap <expr> , <sid>HandlingEndingPair(',')
inoremap <expr> / <sid>HandlingEndingPair('/')
" Ruins the ability to use abbreviations since space is no longer space
" inoremap <expr> <Space> <sid>HandlingEndingPair(' ')
inoremap <expr> > <sid>HandlingEndingPair('>')
inoremap <expr> ] <sid>HandlingEndingPair(']')

" Ruins the ability to use abbreviations
let pairing_characters = ["[]", "{}", "''", "\"\"", "()", "**", "\/\/", "<>", "  ", "--", "``"]
inoremap <expr> <BS>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<Right>\<BS>\<BS>" : "\<BS>"
inoremap <expr> <CR>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<CR>\<Esc>O" : "\<CR>"
" inoremap <expr> <Space>  index(pairing_characters, strpart(getline('.'), col('.')-2, 2)) >= 0 ? "\<Space>\<Space>\<Left>" : "\<Space>"


" function! s:InsertExpr(char)
  " let line = getline('.')
  " let col  = col('.')
  " return 
        " \   line[col-3] =~ '[=<>!~]' ? "\<bs>".a:char." "
        " \ : line[col-2] =~ '\s\+'    ? a:char." "
        " \ :                            a:char
" endfunction
" inoremap <buffer> <expr> = <sid>InsertExpr('=')
" inoremap <buffer> <expr> < <sid>InsertExpr('<')
" inoremap <buffer> <expr> > <sid>InsertExpr('>')
"   }

"   Operator-Pending Mappings {
onoremap p i(
vnoremap p i(
" Function argument selection (change "around argument", change "inside argument")
onoremap ia :<C-u>execute "normal! ?[,(]\rwv/[),]\rh"<CR>
vnoremap ia :<C-u>execute "normal! ?[,(]\rwv/[),]\rh"<CR>")])]" "
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

" Searching {
" Highlight search matches
set hlsearch

" Ignore case when searching
set ignorecase

nnoremap * /\v\C<<C-R>=expand('<cword>')<CR>><CR>
nnoremap # ?\v\C<<C-R>=expand('<cword>')<CR>><CR>
nnoremap <Leader>sc :%s/\v\C(<<C-r>=expand('<cword>')<CR>>)/\=substitute("<C-r>=expand('<cword>')<CR>", "\\C\\([^A-Z]\\)\\([A-Z]\\)", "\\1_\\2", "g")/gc<CR>
nnoremap <Leader>cc :%s/\v\C(<<C-r>=expand('<cword>')<CR>>)/\=substitute("<C-r>=expand('<cword>')<CR>", "\\C_\\([a-z]\\)", "\\u\\1", "g")/gc<CR>
command! ToSnakeCase
      \ exec "norm \"xygn" |
      \ let @y = substitute(@x, "\\C\\([^A-Z]\\)\\([A-Z]\\)", "\\1_\\2", "g") |
      \ let @y = tolower(@y) |
      \ exec "norm cgn\<C-r>y" |
      \ let @@ = ":ToSnakeCase\n"
command! ToCamelCase
      \ exec "norm \"xygn" |
      \ let @y = substitute(@x, "\\C_\\([a-z]\\)", "\\u\\1", "g") |
      \ exec "norm cgn\<C-r>y" |
      \ let @@ = ":ToCamelCase\n"

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
highlight clear SpecialKey
highlight SpecialKey ctermfg=Green guifg=Green
set list
set listchars=tab:>\ 
set listchars+=trail:-
" set listchars+=trail:!
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

" Highlighting Errors {
let bit_operations = "*&|"
let bit_operations_after = "|[". bit_operations ."]{1,2}\\w"
let bit_operations_before = "|\\w[". bit_operations ."]{1,2}"
let space_tab = "| +\t+|\t+ +"

let pattern = "\\s(if|for|while)\\(" . space_tab
" autocmd FileType cpp,c let pattern = pattern.bit_operations_after.bit_operations_before
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
