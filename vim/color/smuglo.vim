" Smuglo
" Author: Nate Hart
" 
" Colors:
" 	Brown:	#584a3b
" 		Light:		#e6ac8a
" 		Highlight:	#80604c
" 	Green:	#d5de32
" 	Cream:	#fbf6e2
" 	Grey:	#998e8b
"	(Error Colors)
" 	Red:	#ff0000
" 	White:	#ffffff

hi clear

set background=light

if exists("syntax_on")
	syntax reset
endif

let g:colors_name="smuglo"


hi Normal			guifg=#fbf6e2 guibg=#584a3b
hi Comment			guifg=#998e8b
hi CursorLine					  guibg=#80604c
hi CursorColumn					  guibg=#80604c
hi LineNR			guifg=#584a3b guibg=#fbf6e2
hi Nontext			guifg=#fbf6e2

hi Boolean			guifg=#e6ac8a
hi Character		guifg=#e6ac8a guibg=#80604c
hi Number			guifg=#e6ac8a
hi String			guifg=#e6ac8a
hi Conditional		guifg=#d5de32
hi Constant			guifg=#d5de32
hi Cursor			guifg=#ffffff guibg=#d5de32
"hi Debug			
"hi Define			
hi Delimiter		guifg=#fbf6e2
"hi DiffAdd			
"hi DiffChange		
"hi DiffDelete		
"hi DiffText		

hi Directory		guifg=#d5de32
hi Error			guifg=#ffffff guibg=#ff0000
hi ErrorMsg			guifg=#ffffff guibg=#ff0000
"hi Exception		
"hi Float			
"hi FoldColumn		
"hi Folded			
hi Function			guifg=#d5de32
hi Identifier		guifg=#d5de32
"hi Ignore			
"hi IncSearch		

"hi Keyword			
"hi Label			
"hi Macro			

hi MatchParen		guifg=#584a3b guibg=#fbf6e2 gui=none
hi ModeMsg			guifg=#fbf6e2
"hi MoreMsg			
hi Operator			guifg=#d5de32

" Completion menu
hi Pmenu			guifg=#584a3b guibg=#d5de32
hi PmenuSel			guifg=#584a3b guibg=#fbf6e2 gui=bold
hi PmenuSbar		guifg=#584a3b guibg=#564033
hi PmenuThumb		guifg=#d5de32 guibg=#cfd90c

hi PreCondit		guifg=#d5de32
hi PreProc			guifg=#d5de32
hi Question			guifg=#cc2929
hi Repeat			guifg=#d5de32
hi Search			guifg=#584a3b guibg=#fbf6e2

" Sign column
hi SignColumn					  guibg=#998e8b
hi SpecialChar		guifg=#e6ac8a guibg=#80604c
hi SpecialComment	guifg=#fbf6e2
hi Special			guifg=#fbf6e2
hi SpecialKey		guifg=#998e8b
if has("spell")
	hi SpellBad		guisp=#d5de32 gui=undercurl
	hi SpellCap		guisp=#d5de32 gui=undercurl
	hi SpellLocal	guisp=#d5de32 gui=undercurl
	hi SpellRare	guisp=#d5de32 gui=undercurl
endif
hi Statement		guifg=#d5de32 gui=none
hi StatusLine		guifg=#d5de32 guibg=#584a3b
hi StatusLineNC		guifg=#fbf6e2 guibg=#584a3b
hi StorageClass		guifg=#d5de32 gui=italic
"hi Structure		
hi Tag				guifg=#d5de32 guibg=#80604c
hi Title			guifg=#fbf6e2 gui=none
hi Todo				guifg=#584a3b guibg=#d5de32

hi Typedef			guifg=#d5de32
hi Type				guifg=#d5de32 gui=none
"hi Underlined		

hi VertSplit		guifg=#fbf6e2 guibg=#fff9e6
"hi VisualNOS		
"hi Visual			
"hi WarningMsg		
hi WildMenu			guifg=#584a3b guibg=#fbf6e2 gui=bold


" HTML
hi htmlTagName		guifg=#e6ac8a
hi htmlTagN			guifg=#e6ac8a
hi htmlArg			guifg=#998e8b
hi htmlString		guifg=#d5de32

" JavaScript
hi javascriptFunction	guifg=#d5de32

