" Momiji 2
" Author: Nate Hart
" 
" Colors:
" 	Background:	#ffffff
" 		Highlight:	#80604c
" 	Red:		#ff3232
" 	Grey:		#262626
" 		Light:		#9bb1bf
" 		Dark:		#6b818f
" 	Orange:		#fc8619
"	(Error Colors)
" 	Red:		#ff0000
" 	White:		#ffffff

hi clear

set background=light

if exists("syntax_on")
	syntax reset
endif

let g:colors_name="momiji"


hi Normal			guifg=#262626 guibg=#ffffff
hi Comment			guifg=#9bb1bf
hi CursorLine					  guibg=#80604c
hi CursorColumn					  guibg=#80604c
hi LineNR			guifg=#ffffff guibg=#9bb1bf
hi Nontext			guifg=#262626

hi Boolean			guifg=#fc8619
hi Character		guifg=#fc8619 guibg=#80604c
hi Number			guifg=#ff3232
hi String			guifg=#ff3232
hi Conditional		guifg=#ff3232
hi Constant			guifg=#ff3232
hi Cursor			guifg=#ffffff guibg=#ff3232
"hi Debug			
"hi Define			
hi Delimiter		guifg=#262626
"hi DiffAdd			
"hi DiffChange		
"hi DiffDelete		
"hi DiffText		

hi Directory		guifg=#ff3232
hi Error			guifg=#ffffff guibg=#ff0000
hi ErrorMsg			guifg=#ffffff guibg=#ff0000
"hi Exception		
"hi Float			
"hi FoldColumn		
"hi Folded			
hi Function			guifg=#fc8619
hi Identifier		guifg=#ff3232
"hi Ignore			
"hi IncSearch		

"hi Keyword			
"hi Label			
"hi Macro			

hi MatchParen		guifg=#ffffff guibg=#262626 gui=none
hi ModeMsg			guifg=#262626
"hi MoreMsg			
hi Operator			guifg=#ff3232

" Completion menu
hi Pmenu			guifg=#eeeeee guibg=#262626
hi PmenuSel			guifg=#ffffff guibg=#ff3232
hi PmenuSbar		guifg=#eeeeee guibg=#eeeeee
hi PmenuThumb		guifg=#666666 guibg=#262626

hi PreCondit		guifg=#ff3232
hi PreProc			guifg=#ff3232
hi Question			guifg=#cc2929
hi Repeat			guifg=#ff3232
hi Search			guifg=#ffffff guibg=#262626

" Sign column
hi SignColumn					  guibg=#9bb1bf
hi SpecialChar		guifg=#fc8619 guibg=#80604c
hi SpecialComment	guifg=#262626
hi Special			guifg=#262626
hi SpecialKey		guifg=#9bb1bf
if has("spell")
	hi SpellBad		guisp=#ff3232 				gui=undercurl
	hi SpellCap		guisp=#ff3232 				gui=undercurl
	hi SpellLocal	guisp=#ff3232 				gui=undercurl
	hi SpellRare	guisp=#ff3232 				gui=undercurl
endif
hi Statement		guifg=#ff3232 				gui=bold
hi StatusLine		guifg=#6b818f guibg=#ffffff
hi StatusLineNC		guifg=#9bb1bf guibg=#ffffff
hi StorageClass		guifg=#ff3232 				gui=italic
"hi Structure		
hi Tag				guifg=#ff3232 guibg=#80604c
hi Title			guifg=#262626 				gui=none
hi Todo				guifg=#ffffff guibg=#ff3232

hi Typedef			guifg=#ff3232
hi Type				guifg=#fc8619 				gui=none
"hi Underlined		

hi VertSplit		guifg=#9bb1bf guibg=#9bb1bf
"hi VisualNOS		
"hi Visual			
"hi WarningMsg		
hi WildMenu			guifg=#ffffff guibg=#262626 gui=bold


" HTML
hi htmlTagName		guifg=#fc8619
hi htmlTagN			guifg=#fc8619
hi htmlArg			guifg=#9bb1bf
hi htmlString		guifg=#ff3232

" JavaScript
hi javascriptFunction	guifg=#ff3232

