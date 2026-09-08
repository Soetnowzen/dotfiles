
let g:comment_map = {
			\ "ahk": ';',
			\ "automake": '#',
			\ "bash_profile": '#',
			\ "bashrc": '#',
			\ "bat": 'REM',
			\ "c": '//',
			\ "cfg": '#',
			\ "conf": '#',
			\ "config": '#',
			\ "cpp": '//',
			\ "csh": '#',
			\ "desktop": '#',
			\ "eml": '>',
			\ "erlang": '%',
			\ "fstab": '#',
			\ "gdb": '#',
			\ "gitconfig": '#',
			\ "go": '//',
			\ "haskell": '--',
			\ "java": '//',
			\ "javascript": '//',
			\ "lisp": ';;',
			\ "lua": '--',
			\ "mail": '>',
			\ "make": '#',
			\ "markdown": '[//]: #',
			\ "php": '//',
			\ "plaintex": '%',
			\ "pov": '#',
			\ "profile": '#',
			\ "proto": '//',
			\ "python": '#',
			\ "ruby": '#',
			\ "rust": '//',
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

function! ToggleComment() range
	if !has_key(g:comment_map, &filetype)
		echo "No comment leader found for filetype"
		return
	endif

	let comment_leader = g:comment_map[&filetype]
	let comment_pattern = escape(comment_leader, '\\.^$~[]/')
	for line_number in range(a:firstline, a:lastline)
		let line = getline(line_number)
		if line =~# '^\s*$'
			continue
		endif

		let uncommented = substitute(line, '^\(\s*\)' . comment_pattern . '\%([[:space:]]\|$\)', '\1', '')
		if uncommented !=# line
			call setline(line_number, uncommented)
		else
			let indent = matchstr(line, '^\s*')
			call setline(line_number, indent . comment_leader . ' ' . strpart(line, strlen(indent)))
		endif
	endfor
endfunction

nnoremap <Leader><Space> :call ToggleComment()<CR>
vnoremap <C-m> :call ToggleComment()<CR>
nnoremap <C-m> :call ToggleComment()<CR>
vnoremap <Leader>m :call ToggleComment()<CR>
