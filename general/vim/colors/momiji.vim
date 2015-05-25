" Momiji
" Author: Nate Hart
"
" Colors:
" 	Primary (red):
" 		normal:	#ff3232
" 		light:	#ffe5e5
" 	Secondary (orange):
" 		normal:	#cc4f29
" 	Tertiary (blue):
" 		light:	#9bb1bf
" 		dark:	#687680

hi clear

set background=light

if exists("syntax_on")
	syntax reset
endif

let g:colors_name="momiji"


hi Normal			guifg=#262626 guibg=#ffffff
hi Comment			guifg=#a6a6a6
hi CursorLine					  guibg=#f2f2f2
hi CursorColumn					  guibg=#f2f2f2
hi LineNr			guifg=#bbbbbb guibg=#ffffff
hi NonText			guifg=#e9e9e9

hi Boolean			guifg=#cc4f29
hi Character		guifg=#ff3232 guibg=#ffe5e5
hi Number			guifg=#cc4f29
hi String			guifg=#cc4f29
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

"hi Directory		
hi Error			guifg=#8b0000
hi ErrorMsg			guifg=#ffffff guibg=#ff3232
hi Exception		guifg=#868686
"hi Float			
"hi FoldColumn		
"hi Folded			
hi Function			guifg=#ff3232
hi Identifier		guifg=#262626
"hi Ignore			
"hi IncSearch		

"hi Keyword			
hi Label			guifg=#868686
hi Macro			guifg=#868686
"hi SpecialKey		

hi MatchParen		guifg=#ffffff guibg=#262626 gui=none
hi ModeMsg			guifg=#cc2929
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
"hi SignColumn		
hi SpecialChar		guifg=#ff3232 guibg=#ffe5e5
hi SpecialComment	guifg=#565656
hi Special			guifg=#868686
"hi SpecialKey		
if has("spell")
	hi SpellBad		guisp=#ff3232 gui=undercurl
	hi SpellCap		guisp=#ff3232 gui=undercurl
	hi SpellLocal	guisp=#ff3232 gui=undercurl
	hi SpellRare	guisp=#ff3232 gui=undercurl
endif
hi Statement		guifg=#ff3232 gui=none
hi StatusLine		guifg=#dddddd guibg=#868686
hi StatusLineNC		guifg=#dddddd guibg=#868686
hi StorageClass		guifg=#ff3232
hi Structure		guifg=#868686
hi Tag				guifg=#ff3232 guibg=#ffe5e5
hi Title			guifg=#262626 gui=none
hi Todo				guifg=#262626 guibg=#f2f2f2

hi Typedef			guifg=#868686
hi Type				guifg=#262626 gui=none
"hi Underlined		

hi VertSplit		guifg=#dddddd guibg=#dddddd
"hi VisualNOS		
"hi Visual			
"hi WarningMsg		
hi WildMenu			guifg=#ffffff guibg=#ff3232


" HTML
hi htmlTagN		guifg=#ff3232
hi htmlTagName	guifg=#ff3232
hi htmlArg		guifg=#9bb1bf
hi htmlString	guifg=#687680
hi htmlLink		guifg=#565656 gui=underline

" JavaDoc
hi javaDocParam		guifg=#565656
