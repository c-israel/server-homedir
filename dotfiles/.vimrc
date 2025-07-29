set nocompatible  			" Vim-Modus

set encoding=utf-8
set fileencoding=utf-8

colorscheme slate
set background=dark

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set backup					" keep backup files
set backupdir=/tmp			" directory for backups
set directory=/tmp			" directory for temp files 

set history=100				" keep 100 lines of command line history
set noruler					" never show ruler <!--show the cursor position all the time-->
set sessionoptions-=options

" set the status line to look like 'ruler', plus buffer number at the end
""set statusline=%<%f%h%m%r%w%y%=ln{%l/%L}col{%c}\ %P
set statusline=%<%f%h%m%r%w%y\ \ %{strftime('mod:%d.%m.%y-%H:%M',getftime(expand(\"%%\")))}%=%{expand('%:h')}\ \ \ ln{%l/%L}col{%c}\ %P  

set laststatus=2
set number			" show line numbers
set showcmd			" display incomplete commands
set incsearch		" do incremental searching
syntax on 			" syntax highlighting
set hlsearch		" highlight search results

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

set cursorline      " highlight current line

set wildmode=full 	" command line completion
set completeopt=menu,preview,longest "Insert Mode Completion

map Q g		 		" Don't use Ex mode, use Q for formatting
map E ge            " E goes backwards to the end of the last word
nmap \| i<CR><Esc> 	" split line
map <Help> <Esc>
map! <Help> <Esc>
imap <S-CR> <Esc>o

" screen fixes
if expand('$TERM') == 'screen'
	imap OA <up>
	imap OB <down>
	imap OD <left>
	imap OC <right>
	cmap <ESC>[Z <S-Tab>
	"	unmap <ESC>[Z
endif


" Tabs and spaces
set smartindent		" intelligent automatic indention
set tabstop=4    	" tab width 4 chars
set shiftwidth=4 	" indent width 4 chars
set softtabstop=4 	" automatically replace 4 chars with tabs
"set expandtab 		" automatically replace tabs when saving

set hidden			" allow switching away from changed buffers

map gb :bn<CR>
map gB :bp<CR>
map <C-n> :bn<CR>
map # :noh<CR>
map Y y$
map Ö :cp<CR> 
map Ä :cn<CR> 
cmap  =expand("%:h")<CR>/
"  expands current directory

set updatetime=1000 " updatetime to a quarter

map + <C-W>+
map - <C-W>-
map <C-l> <C-W>>
map <C-h> <C-W><

"set foldcolumn=2

" Searches are case-insensitive if all lowercase. If contain mixed-case,
" search becomes case-sensitive. Only works with 'set ignorecase'.
set ignorecase
set smartcase

" Modifizierte Version von Tip572:
" http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
" Benutzt match anstatt der Suchvariable @/
" Dadurch wird nicht automatisch die letzte Suche überschrieben
augroup cursorhl
"" Highlight all instances of word under cursor, when idle.
"" Useful when studying strange source code.
"" Turn on/off with z/ (or key of your choice)
map z/ :call Auto_Highlight_Toggle()<CR>

function! Auto_Highlight_Cword()
  exe "match cursorhighlight /\\<".expand("<cword>")."\\>/"
endfunction

function! Auto_Highlight_Toggle()
  highlight cursorhighlight ctermfg=white ctermbg=grey guifg=black guibg=grey
  if exists("g:cursorhold_autohl")
	unlet g:cursorhold_autohl
    au! CursorHold *
	match
  else
	let g:cursorhold_autohl = 1
    "set updatetime=500
    au! CursorHold * nested call Auto_Highlight_Cword()
  endif
endfunction
augroup	END


set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait0-blinkoff0-blinkon0
