" Vim syntax file
" Language: Logfiles
" Maintainer: Soetnowzen
" Latest Revision: 29 Januari 2018

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword syntaxElementKeyword keyword1 keyword2 nextgroup=syntaxElement2
syn keyword basicLanguageKeywords PRINT OPEN IF
syn keyword basicLanguageKeywords DO WHILE WEND
syn keyword celBlockCmd RA Dec SpectralType Mass Distance AbsMag nextgroup=celNumber skipwhite
syn keyword celBlockCmd RA Dec Distance AbsMag nextgroup=celNumber
syn keyword celBlockCmd SpectralType nextgroup=celDesc

" Matches
syn match syntaxElementMatch 'regexp' contains=syntaxElement1 nextgroup=syntaxElement2 skipwhite
" Integer with - + or nothing in front
syn match celNumber '\d\+' contained display
syn match celNumber '[-+]\d\+' contained display
" Floating point number with decimal no E or e
syn match celNumber '[-+]\d\+\.\d*' contained display
" Floating point like number with E and no decimal point (+,-)
syn match celNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+' contained display
syn match celNumber '\d[[:digit:]]*[eE][\-+]\=\d\+' contained display
" Floating point like number with E and decimal point (+,-)
syn match celNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' contained display
syn match celNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+' contained display

syn match celHip '\d\{1,6}' nextgroup=celString

syn match warnOrErr 'fail\w*'
syn match warnOrErr 'err\w*'
syn match celHip 'warn\w*'
syn match celHip 'info\w*'
syn match celTodo '\w\+=[\w\-]\+(,\w\+=[\w\-]\+)\+'

" Regions
syn region syntaxElementRegion start='x' end='y'
syn region celDesc start='"' end='"'

syn region celDescBlock start="{" end="}" fold transparent contains=ALLBUT,celHip,celString

let b:current_syntax = "cel"

hi def link celTodo        Todo
hi def link celComment     Comment
hi def link celBlockCmd    Statement
hi def link celHip         Type
hi def link celString      Constant
hi def link celDesc        PreProc
hi def link celNumber      Constantlet
hi def link warnOrErr      Special	

