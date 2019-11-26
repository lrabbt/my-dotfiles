" Instal vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Set tabulation to spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Plugins
call plug#begin()
Plug 'tpope/vim-sensible'
call plug#end()

