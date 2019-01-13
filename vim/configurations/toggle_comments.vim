
let s:comment_map = {
      \ "ahk": ';',
      \ "automake": '#',
      \ "bash_profile": '#',
      \ "bashrc": '#',
      \ "bat": 'REM',
      \ "c": '\/\/',
      \ "cfg": '#',
      \ "conf": '#',
      \ "config": '#',
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
      \ "lisp": ';;',
      \ "lua": '--',
      \ "mail": '>',
      \ "make": '#',
      \ "php": '\/\/',
      \ "plaintex": '%',
      \ "pov": '#',
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
      \ "zsh": '#',
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

nnoremap <Leader><Space> :call ToggleComment()<CR>
vnoremap <C-m> :call ToggleComment()<CR>
nnoremap <C-m> :call ToggleComment()<CR>
vnoremap <Leader>m :call ToggleBlockComment()<CR>
