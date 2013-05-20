" Ideas taken from various people's configurations and http://amix.dk/vim/vimrc.html

" Load pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

" Settings for Powerline
set laststatus=2
set nocompatible
set noshowmode " Hide the default mode text

filetype on
filetype plugin on
filetype indent on

syntax enable

if has("macunix")
	" Load Powerline
	set rtp+=/Users/Nate/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim

	" Mac settings
	colorscheme monokai
	set guifont=Menlo\ Regular\ for\ Powerline:h11

	" Use open to view LaTeX output on OS X
	let g:LatexBox_viewer="open"
else
	" Load Powerline
	set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim

	" Linux settings
	colorscheme molokai
	set guifont=Menlo\ for\ Powerline\ 11
endif

" Set <leader> to ","
let mapleader=","
let g:mapleader=","

" Write out buffers with ,w
nmap <leader>w :w!<cr>

" Save files using sudo with :w!!, for when Vim was not opened with sudo
cmap w!! %!sudo tee > /dev/null %

" Treat long lines as break lines
map j gj
map k gk

" Move between windows using ctrl-h/j/k/l
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Replace selected text in current buffer with ,r
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Search the current working directory using regex with ,sd
noremap <leader>sd :call SearchDirectory()<CR>

" Useful tab mappings
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" cd to the open buffer's directory with ,cd
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Toggle spell checking with ,ss
map <leader>ss :setlocal spell!<cr>

" Remove Windows' ^M when encodings gets messed up with ,m
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm


" Turn on the wild menu
set wildmenu
let wildmode="full"
set wildignore=*.o,*~,*.pyc,*.class " Ignore compiled files

set autoread		" Autoread files that were changed externally
set hid				" Hide buffers when they are abandoned
set ignorecase		" Ignore case when searching
set smartcase		" Be smart about search cases
set hlsearch		" Highlight search results
set incsearch
set number			" Show line numbers
set shiftwidth=4	" 1 tab ~ 4 spaces
set tabstop=4
set smarttab
set ai				" Auto indent
set si				" Smart indent
set wrap			" Wrap lines
set encoding=utf8
set ffs=unix,mac,dos

" Turn backup off
set nobackup
set nowb
set noswapfile

" Remove scrollbar in MacVim/GVim
set guioptions-=r
set guioptions-=l
set guioptions-=L
set guioptions-=b

" Remove toolbars and menu bars in MacVim/GVim
set guioptions-=m
set guioptions-=T

" Enable spell checking for text, markdown, and latex files by default
autocmd BufNewFile,BufRead *.{txt,markdown,tex} setlocal spell spelllang=en_us

" Enable spell checking when writing email
autocmd FileType mail setlocal spell spelllang=en_us

" Use my Jot theme for markdown and tex files
autocmd BufNewFile,BufRead *.{markdown,tex} colorscheme jot

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Remember info about open buffers on close
set viminfo^=%

" Locally (local to block) rename a variable with ,rl (doesn't work for some languages, like Python)
nmap <Leader>rl "zyiw:call ReplaceVarInScope()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x
" Globally rename a variable with ,rg (doesn't work for some languages, like Python)
nmap <Leader>rg "zyiw:call ReplaceVarInScope()<cr>mx:silent! norm gD<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" Delete trailing white space on save, useful for Python and CoffeeScript
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle NERDTree with ,nt
nmap <leader>nt :NERDTreeToggle<cr>

" cd to the directory of the last opened NERDTree bookmark
let NERDTreeChDirMode=2

" Toggle Tagbar with ,tb
nmap <leader>tb :TagbarToggle<cr>

" Add support for Chicken Scheme to SingleCompile
call SingleCompile#SetCompilerTemplate('scheme', 'csi', 'Chicken Scheme', 'csi', '-qb', '')
" Show compile results in a dialog
let g:SingleCompile_usedialog=1
" Show run results after running
let g:SingleCompile_showresultafterrun=1
" SingleCompile key bindings
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>
nmap <F11> :SCViewResult<cr>

" Automatically open and close the location list when syntax errors are detected
let g:syntastic_auto_loc_list=1
" Only show 5 lines of syntax error locations
let g:syntastic_loc_list_height=5
" For fun
let g:syntastic_error_symbol='✖'
let g:syntastic_warning_symbol='⚠'

" Never prompt for saving or loading sessions (vim-session)
let g:session_autoload='no'
let g:session_autosave='no'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! SearchDirectory()
	let l:saved_reg=@z

	let @z=input("Search directory for: ")
	execute "vimgrep /".@z."/gj ./**/*"
	execute "cw"

	let @z=l:saved_reg
endfunction

function! ReplaceVarInScope()
    call inputsave()
    let @z=input("Rename ".@z." to: ")
    call inputrestore()
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :".a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg=@"
    execute "normal! vgvy"

    let l:pattern=escape(@", '\\/.*$^~[]')
    let l:pattern=substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?".l:pattern."^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep ".'/'.l:pattern.'/'.' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s".'/'.l:pattern.'/')
    elseif a:direction == 'f'
        execute "normal /".l:pattern."^M"
    endif

    let @/=l:pattern
    let @"=l:saved_reg
endfunction
