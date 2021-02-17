" Install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Python path
let g:python3_host_prog="python3.8"

" Use powerline font on airline theme
let g:airline_powerline_fonts = 1
let g:airline_theme='wal'

" Set tabulation to spaces
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
set list
autocmd BufNewFile,BufReadPost python setlocal shiftwidth=4

" Set path to find files recursively
set path+=**

" Save undo file
set undofile

" Open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" UltiSnips configuration
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsListSnippets="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"

" Plugins
call plug#begin()

" File management
Plug 'scrooloose/nerdtree'
Plug 'lambdalisue/suda.vim'
Plug 'hauleth/vim-backscratch'

" Appearance
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'dylanaraps/wal.vim'
Plug 'altercation/vim-colors-solarized'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Code formatting
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Code compiling
Plug 'tpope/vim-dispatch'
Plug 'jalaiamitahl/maven-compiler.vim'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Typescript
Plug 'leafgarland/typescript-vim'

" Nim
Plug 'alaviss/nim.nvim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Code completion
Plug 'neovim/nvim-lspconfig'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-lsp'

" File searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Colorscheme
set background=dark
colorscheme solarized

" Deoplete config (high delay IS IMPORTANT!)
let g:deoplete#enable_at_startup = 1
let g:deoplete#lsp#use_icons_for_candidates = v:true

call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#option({
    \ 'auto_complete': v:true,
    \ 'auto_complete_delay': 200,
    \ 'smart_case': v:true,
    \ })

" Enable manual completion
inoremap <silent><expr> <C-space>
      \ deoplete#manual_complete()
" Close preview
autocmd CompleteDone * silent! pclose!
" Navigate menu with TAB
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
inoremap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<S-TAB>" :
      \ deoplete#manual_complete()
" Undo completion
inoremap <expr><C-h>
      \ deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>
      \ deoplete#smart_close_popup()."\<C-h>"

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" Load lspconfig config :)
lua require('lspconfig-init')
