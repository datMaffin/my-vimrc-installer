if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

" My stuff
Plug 'datMaffin/personal-vimrc'
Plug 'datMaffin/vim-colors-bionik'

Plug 'scrooloose/nerdtree'

call plug#end()

" Plugin Settings
" ===============

" NERDTree settings
" -----------------
" Open automatically when no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open when calling vim on directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Close vim when only NERDTree is opened
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NERDTree with ctrl-n
map <C-n> :NERDTreeToggle<CR>

" My Settings
" ===========
colo bionik

set encoding=utf-8
set guifont=Mononoki:h12
set linespace=2  " linespace is specifically set for mononoki
