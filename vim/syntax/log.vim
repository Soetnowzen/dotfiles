syntax match potionOperator "\v\*"
syntax match potionOperator "\v/"
syntax match potionOperator "\v\+"
syntax match potionOperator "\v-"
syntax match potionOperator "\v\?"
syntax match potionOperator "\v\*\="
syntax match potionOperator "\v/\="
syntax match potionOperator "\v\+\="
syntax match potionOperator "\v-\="

syntax match Orange '\d\+:\d\+\(:\d\+\.\d\+\)*'
syntax match Orange '\d\+-\d\+-\d\+'
syntax match Orange '0x[0-9a-fA-F]\+'
syntax match White '\w\+\.[a-zA-Z]\+\(:\d\+\)'
syntax match Blue '\w\+='
syntax match RED '\c\<warn\w*'
syntax match RED '\c\<fail\w*'
syntax match RED '\c\<info\w*'
syntax match RED '\c\<err\w*'

syntax region Cyan start='<' skip='\v\\.' end='>'
syntax region Cyan start='(' skip='\v\\.' end=')'
syntax region Cyan start='\"' skip='\v\\.' end='\"'

syntax match Magenta '\cmakemake'
syntax match Magenta '\cmkmk'
syntax match Green '[a-zA-Z]\+=\w\+,\{0,1\}'
syntax match Violet '\csfa'

highlight link potionOperator Operator
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
