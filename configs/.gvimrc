
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

colorscheme darkZ

"set spell

"""""""""""""""""""""""
" Gvim specific stuff "
"""""""""""""""""""""""

"set guifont=droid\ sans\ mono\ 10

set lines=45
set columns=100

""""""""""""""""""""""""

set visualbell t_vb=    " turn off error beep/flash

set ts=4 sw=4 fdm=marker ft=vim
