
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

colorscheme darkfix

"set spell

"""""""""""""""""""""""
" Gvim specific stuff "
"""""""""""""""""""""""

set guifont=droid\ sans\ mono\ 10

set lines=40
set columns=100

""""""""""""""""""""""""

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
let loaded_matchparen = 0
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"""""""""""""""""""
" Tab or Complete "
"""""""""""""""""""

function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
set dictionary-=/home/sas/docs/compgen.dic  dictionary+=/home/sas/docs/compgen.dic
set complete-=k complete+=k

""""""""""""""""""""""""""""""""""
"""""""""""" SESSIONS """"""""""""
""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""
" Remeber ses. details "
""""""""""""""""""""""""

" Make Vim remember settings like cursor placement and folds,
" when moving between multiple folders,A view of the buffer is 
" saved whenever you show another buffer in the same window, 
" and restored when you show the buffer in the window again.

set viewdir=/home/sas/.vim/views/
"autocmd BufWinLeave * mkview
"autocmd BufWinEnter * silent loadview

"""""""""""""""""""""""""""""""""""""
" Save on close + easy session open "
"""""""""""""""""""""""""""""""""""""

"This trick is to add commands for saving a session when quitting Vim, and restoring
"the session when opening Vim. This way you can open and close Vim without losing
"the settings, list of open files, etc. 

"Now if close Vim, then it saves a session file in
"$HOME/.vim/sessions/session.vim.
"Depending on how you open Vim, it either opens the file specified on the
"command-line or reopens the latest session, for example:

"vim file.txt -Opens Vim without loading the last session
"vim - Opens Vim with the last session loaded. Previously opened
"files are reopened.

function! LoadSession()
	if argc() == 0
		execute 'source /home/sas/.vim/sessions/session.vim'
	endif
endfunction

function! SaveSession()
	execute 'mksession! /home/sas/.vim/sessions/session.vim'
endfunction
autocmd VimEnter * call LoadSession()
autocmd VimLeave * call SaveSession()

""""""""""""""""""
"SESSION OPTIONS "
""""""""""""""""""
"
" :set sessionoptions=<OPTIONS>

"  <OPTIONS> 	 comma-separated list of the following options

"	blank,		  Save empty windows.
"	buffers,	  Save info about all buffers including hidden and
"	    		  unloaded buffers.
"	curdir,		  Save information about current work directory.
"	folds,		  Save information about folds in the buffer contents.
"	globals,	  Save information about global variables. Only variables
"				  starting with an uppercase letter and of the type String
"	    		  or Number will be saved.
"	help,		  Save the help window.
"	localoptions, Save info about local options and mappings you have created
"				  for a single window.
"	options,	  Save all options, both local and global.
"	resize,		  Save info about the size of the UI window (lines and columns).
"	sesdir,		  If set, the current directory is the place where the session file
"   	 		  is saved (cannot be used when curdir is also set).
"	slash,		  Change backslashes in all paths to slashes (make Windows
"	    		  paths Unix compatible).
"	tabpages,	  Save information about all tab pages and not only the active
"   		 	  one, which is default without this option.
"	unix,		  Use Unix line endings, even on Windows systems.
"	winpos,		  Save information on where the UI Window was placed on
" 		   		  the screen.
"	winsize,	  Save the size of all open windows.

set sessionoptions=tabpages,winsize,blank,unix,localoptions,buffers,resize
"set sessionoptions=globals,folds,buffers,resize,help

""""""""""""""""""""""""
" Shortcuts Documented "
""""""""""""""""""""""""

" jj - esc
" ,b - bufferlist
" ,y - yank to clipboard
" ,Y - yank current line to clipboard
" ,p - paste from clipboard
"  Y - yank to the end of the line
"  D - delete to the end of the line
" C-n  - clear search
" ,r - Start replace all
" ,y - yank to clipboard
" ,ss - Save session
" ,so - Open session

""""""""""""""""
" Key Mappings "
""""""""""""""""
let mapleader="'"

map ; :

map <leader>ll <leader>lj

" Maps for jj to act as Esc
ino jj <esc>
cno jj <c-c>

" Y yanks to the end of the line
map Y y$

" D deletes to the end of the line
map D d$

" shortcuts for copying to clipboard
map <leader>y "+y

" copy the current line to the clipboard
map <leader>p "+gP

" easier start replace
map <leader>r R

" easier switch window
map <leader>w <c-w><c-w> 

" Press Ctrl-N to turn off highlighting.
map <silent> <C-N> :silent noh<CR>

" Go 10 lines down
map <leader>d 10j

" Go 10 lines up
map <leader>u 10k

" Goto last place edited
map <leader>. `.

" Nerdtree
map <leader>;; :NERDTreeToggle<CR>

" Make sesions get save & open to same dir
nmap <leader>mm :wa<CR>:mksession! ~/.vim/sessions/

nmap <leader>mo :wa<CR>:so ~/.vim/sessions/

" Make sesios get save & open to same dir
nmap <leader>ss :wa<CR>:mksession! ~/.vim/sessions/

" leader tt opens blank tab
nmap <leader>tt :tabnew<CR>

" leader nn opens new
nmap <leader>nn :enew<CR>

" leader bb inserts bash shebang
nmap <leader>bb a#!/bin/bash<CR><esc>

" leader bb inserts python2 shebang
nmap <leader>pp a#!/usr/bin/env python2<CR><esc>

" leader bb inserts python3 shebang
nmap <leader>ppp a#!/usr/bin/env python3<CR><esc>

" easier start replace
map <leader>r R

" leader tt opens blank tab
nmap <leader>tt :tabnew<CR>

" Go 10 lines up
map <leader>u 10k

" easier switch window
map <leader>w <c-w><c-w> 

" sudo if open w/out perm
"nmap <leader>ww :w !sudo tee %<CR>
"cmap hhh w !gksudo tee >/dev/null %
" shortcuts for copying to clipboard
map <leader>y "+y

" Goto last place edited
map <leader>. `.

" Save
nmap <leader>] :w<CR>

" Save and close
nmap <leader>[ :wq<CR>

" Nerdtree
map <leader>;; :NERDTreeToggle<CR>

"""""""""""""""""
" More settings "
"""""""""""""""""

set title               " show title in console title bar
set visualbell t_vb=    " turn off error beep/flash
set ttyfast             " smoother changes
set modeline            " last lines in document sets vim mode
set modelines=3         " number lines checked for modelines
set hlsearch            " highlight searches
set incsearch           " do incremental searching
set ignorecase          " ignore case when searching
set smartcase           " if searching and search contains upper case, make case sensitive search
set autowrite 			" autosave when switching buffers

"""""""""""""
" Filetypes "
"""""""""""""

" Auto change the directory to the current file I'm working on
autocmd BufEnter * lcd %:p:h

"A function to tell if a file is executable
"function! FileExecutable (fname)
"execute "silent! ! test -x" a:fname
"return v:shell_error
"endfunction
"" Automatically make Pl Py & Shell scripts executable if they aren't already
"au BufWritePost *.py,*.sh,*.pl,*.cgi if FileExecutable("%:p") | :!chmod a+x % ^@ endif

"au BufWritePost * if getline(1) =~ "^! ?/bin/[a-z]*sh" | silent !chmod a+x <afile>
"au BufWritePost * | endif
"
" automatically give executable permissions if file begins with #! and contains
" '/bin/' in the path
au bufwritepost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod a+x <afile> | endif | endif   
"" automatically give executable permissions if filename is *.sh
"au BufWritePost *.sh :!chmod a+x <afile>
""au BufWritePost *.py :!chmod a+x <afile>
"au BufWritePost *.pl :!chmod a+x <afile>
"" automatically
" More settings "
"""""""""""""""""

set title               " show title in console title bar
set visualbell t_vb=    " turn off error beep/flash
set ttyfast             " smoother changes
set modeline            " last lines in document sets vim mode
set modelines=3         " number lines checked for modelines
set hlsearch            " highlight searches
set incsearch           " do incremental searching
set ignorecase          " ignore case when searching
set smartcase           " if searching and search contains upper case, make case sensitive search
set autowrite 			" autosave when switching buffers

"""""""""""""
" Filetypes "
"""""""""""""

" Auto change the directory to the current file I'm working on
autocmd BufEnter * lcd %:p:h

"A function to tell if a file is executable
function! FileExecutable (fname)
  execute "silent! ! test -x" a:fname
  return v:shell_error
endfunction
"" Automatically make Pl Py & Shell scripts executable if they aren't already
au BufWritePost *.py,*.sh,*.pl,*.cgi if FileExecutable("%:p") | :!chmod a+x % ^@ endif

"au BufWritePost * if getline(1) =~ "^#! ?/bin/[a-z]*sh" | silent !chmod a+x <afile>
"au BufWritePost * | endif

"" automatically give executable permissions if filename is *.sh
"au BufWritePost *.sh :!chmod a+x <afile>
""au BufWritePost *.py :!chmod a+x <afile>
"au BufWritePost *.pl :!chmod a+x <afile>
"" automatically give executable permissions if file begins with #!/bin/sh
""au BufWritePost * if getline(1) =~ "^#!/bin/[a-z]*sh" | silent !chmod a+x <afile> | endif
"au BufWritePost * if getline(1) =~ "^#!/usr/bin/env*" | silent !chmod a+x <afile> | endif



set ts=4 sw=4 fdm=marker ft=vim
