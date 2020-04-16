" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Use powerline font on airline theme
let g:airline_powerline_fonts = 1

" Use dark solarized theme on Vim
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" Set tabulation to spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
autocmd BufNewFile,BufReadPost python setlocal shiftwidth=4

" Set path to find files recursively
set path+=**

" Open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" YouCompleteMe configuration
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/.global_extra_conf.py'

" Plugins
call plug#begin()

" File management
Plug 'scrooloose/nerdtree'
Plug 'lambdalisue/suda.vim'

" Appearance
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code formatting
Plug 'tpope/vim-surround'

" Code compiling
Plug 'tpope/vim-dispatch'

" Typescript
Plug 'leafgarland/typescript-vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Code completion
Plug 'valloric/youcompleteme'

" File searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

