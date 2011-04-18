
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

set visualbell t_vb=    " turn off error beep/flash

set ts=4 sw=4 fdm=marker ft=vim
