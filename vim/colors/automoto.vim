" Automoto
" Author: Nate Hart
" 
" Colors:
" 	Background:	#ff273f
" 		Light:		#e6ac8a
" 		Highlight:	#80604c
" 	Primary:	#396300
" 	Text:		#ffffff
" 	Comments:	#333333
"	(Error Colors)
" 	Red:		#ff0000
" 	White:		#ff273f

hi clear

set background=light

if exists("syntax_on")
	syntax reset
endif

let g:colors_name="automoto"


hi Normal			guifg=#ffffff guibg=#ff273f
hi Comment			guifg=#333333
hi CursorLine					  guibg=#80604c
hi CursorColumn					  guibg=#80604c
hi LineNR			guifg=#ff273f guibg=#ffffff
hi Nontext			guifg=#ffffff

hi Boolean			guifg=#e6ac8a
hi Character		guifg=#e6ac8a guibg=#80604c
hi Number			guifg=#e6ac8a
hi String			guifg=#e6ac8a
hi Conditional		guifg=#396300
hi Constant			guifg=#396300
hi Cursor			guifg=#ff273f guibg=#396300
"hi Debug			
"hi Define			
hi Delimiter		guifg=#ffffff
"hi DiffAdd			
"hi DiffChange		
"hi DiffDelete		
"hi DiffText		

hi Directory		guifg=#396300
hi Error			guifg=#ff273f guibg=#ff0000
hi ErrorMsg			guifg=#ff273f guibg=#ff0000
"hi Exception		
"hi Float			
"hi FoldColumn		
"hi Folded			
hi Function			guifg=#396300
hi Identifier		guifg=#396300
"hi Ignore			
"hi IncSearch		

"hi Keyword			
"hi Label			
"hi Macro			

hi MatchParen		guifg=#ff273f guibg=#ffffff gui=none
hi ModeMsg			guifg=#ffffff
"hi MoreMsg			
hi Operator			guifg=#396300

" Completion menu
hi Pmenu			guifg=#396300 guibg=#ffffff
hi PmenuSel			guifg=#ffffff guibg=#396300 gui=bold
hi PmenuSbar		guifg=#ff273f guibg=#ff363f
hi PmenuThumb		guifg=#ffffff guibg=#ffffff

hi PreCondit		guifg=#396300
hi PreProc			guifg=#396300
hi Question			guifg=#cc2929
hi Repeat			guifg=#396300
hi Search			guifg=#ff273f guibg=#ffffff

" Sign column
hi SignColumn					  guibg=#333333
hi SpecialChar		guifg=#e6ac8a guibg=#80604c
hi SpecialComment	guifg=#ffffff
hi Special			guifg=#ffffff
hi SpecialKey		guifg=#333333
if has("spell")
	hi SpellBad		guisp=#396300 				gui=undercurl
	hi SpellCap		guisp=#396300 				gui=undercurl
	hi SpellLocal	guisp=#396300 				gui=undercurl
	hi SpellRare	guisp=#396300 				gui=undercurl
endif
hi Statement		guifg=#396300 				gui=bold
hi StatusLine		guifg=#396300 guibg=#ffffff gui=none
hi StatusLineNC		guifg=#ffffff guibg=#ff273f
hi StorageClass		guifg=#396300 				gui=italic
"hi Structure		
hi Tag				guifg=#396300 guibg=#80604c
hi Title			guifg=#ffffff 				gui=none
hi Todo				guifg=#ff273f guibg=#396300

hi Typedef			guifg=#396300
hi Type				guifg=#396300 				gui=none
"hi Underlined		

hi VertSplit		guifg=#ffffff guibg=#fff9e6
"hi VisualNOS		
"hi Visual			
"hi WarningMsg		
hi WildMenu			guifg=#ff273f guibg=#ffffff gui=bold


" HTML
hi htmlTagName		guifg=#e6ac8a
hi htmlTagN			guifg=#e6ac8a
hi htmlArg			guifg=#333333
hi htmlString		guifg=#396300

" JavaScript
hi javascriptFunction	guifg=#396300

