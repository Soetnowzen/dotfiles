set nocompatible
filetype off
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

if &term =~ "xterm\\|urxvt"
  let &t_SI .= "\<Esc>[5 q"
  let &t_EI .= "\<Esc>[1 q"
endif

" vimdiff opens in vertical mode now
" set diffopt=vertical

" Sets row numbers
set number

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

" normal mode remap case switch
nnoremap � ~

" visual mode remap case switch
vnoremap � ~

nnoremap <space> :noh<cr>

" Insertion mode remaps
inoremap :w<cr> <Esc>:w<cr>a
inoremap :wq<cr> <Esc>:wq<cr>
inoremap jj <Esc>

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
" set fdm=marker
" set fmr={,}
" set fdm=syntax
" syn region csFold start="{" end="}" transparent fold

" Leave a few lines when scrolling
set scrolloff=3

" Changes tabulary to spaces
set expandtab

" Tabs only two spaces
set tabstop=2
set shiftwidth=2

au BufRead,BufNewFile *.py,*.pyw,*.pl set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw,*.pl set tabstop=4
au BufRead,BufNewFile *.tex,*.txt set spell spelllang=en_us
au BufRead,BufNewFile Makefile* set noexpandtab

" Central directory for swap files
set backup
set directory-=$HOME/.vim/.backup
set directory^=$HOME/.vim/.backup//
set backupdir-=$HOME/.vim/.backup
set backupdir^=$HOME/.vim/.backup//
set writebackup

"set backupdir=./backup,.,/tmp
"set directory=.,./.backup,/tmp
"set directory=~/.vim/temp//,.

" Removes useless gui crap
set guioptions-=M
set guioptions-=T
set guioptions-=m
set guioptions-=r

" Doesn't save swp-files after each session
" set nobackup
" set noundofile

" :e ignores files
"set wildignore=*.o, *.exe, *.hi, *.swp

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'

call vundle#end()
filetype plugin indent on

" ctrlp.vim basic options
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_map = '<c-p>'

" Map Ctrl-n to open the NERDTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.hi$', '\.o$', '\.dyn_hi$', '\.dyn_o$']
let NERDTreeQuitOnOpen = 1

" Syntastic stuff
let g:syntastic_check_on_open=1
let g:syntastic_enable_perl_checker=1
let g:syntastic_enable_signs=1
let g:syntastic_check_on_open=1

set splitbelow
set splitright

" Sets colors based on a dark background
" if gvim else vim
syntax enable
let g:solarized_bold=0 " 0 | 1
let g:solarized_italic=0 " 0 | 1
let g:solarized_termcolors=16 " 16 | 256
let g:solarized_termtrans=0 " 0 | 1
let g:solarized_underline=0 " 0 | 1
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
    set lines=64
  endif
else
  let g:solarized_contrast="high" " low | normal | high
  let g:solarized_visibility="high" " low | normal | high
  set background=dark
endif
colorscheme solarized

" Creates a Bobo for marking error spaces
highlight Bobo guifg=Magenta ctermfg=Magenta
highlight ColorColumn guifg=Magenta ctermfg=Magenta
highlight trail guifg=Magenta ctermfg=Magenta

" Error tokens after 80 tokens
" let &colorcolumn=join(range(81,999),",")
set colorcolumn=81,82,83
au BufRead,BufNewFile *.py,*.pyw,*.pl set colorcolumn=121,122,123

" Highlight trailing spaces
augroup trailing
  au!
  au InsertEnter * :match none /\s\+$/
  au InsertLeave * :match trail /\s\+$/
augroup END

" Show search matches while typing
set incsearch

" Show autocompletion options
set wildmenu
set wildmode=list:longest,full

" Added a new command to remove trailing spaces
" (search and replace / whitespaces / one or more, end of line)
command RemoveSpaces %s/\s\+$/