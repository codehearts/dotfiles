" Jot
" Author: Nate Hart
" 
" Colors:
" 	Background:	#f9ffff
" 	Normal:		#262626
" 		Light:		#b6b6b6
"	Highlight:	#0c9cf0
"		Light:		#e4ecf0
"		Dark:		#0e5591
"	Error:		#f0090c

hi clear

set background=light

if exists("syntax_on")
	syntax reset
endif

let g:colors_name="jot"


hi Normal			guifg=#262626 guibg=#f9ffff
hi Comment			guifg=#b6b6b6
hi CursorLine					  guibg=#e4ecf0
hi CursorColumn					  guibg=#e4ecf0
hi LineNR			guifg=#b6b6b6 guibg=#f9ffff
hi Nontext			guifg=#b6b6b6 				gui=none

hi Constant			guifg=#0e5591
hi Delimiter		guifg=#0c9cf0

hi MatchParen		guifg=#ffffff guibg=#0c9cf0 gui=bold

hi Operator			guifg=#0e5591

hi PreCondit		guifg=#0e5591
hi PreProc			guifg=#0c9cf0

hi Special			guifg=#0e5591
if has("spell")
	hi SpellBad		guisp=#f0090c 				gui=undercurl
	hi SpellCap		guisp=#f0090c 				gui=undercurl
	hi SpellLocal	guisp=#f0090c 				gui=undercurl
	hi SpellRare	guisp=#f0090c 				gui=undercurl
endif
hi Statement		guifg=#0c9cf0 				gui=none
hi Title			guifg=#262626 				gui=bold

hi Type				guifg=#b6b6b6 				gui=none

hi VertSplit		guifg=#0c9cf0 guibg=#0c9cf0
