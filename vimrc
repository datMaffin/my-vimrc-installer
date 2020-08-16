if has('nvim')
    if empty(glob(stdpath('data') . '/autoload/plug.vim'))
        silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif


if has('nvim')
    call plug#begin(stdpath('data') . '/plugged')
else
    call plug#begin('~/.vim/plugged')
endif


" My stuff
Plug 'datMaffin/personal-vimrc'
Plug 'datMaffin/vim-colors-bionik'

Plug 'scrooloose/nerdtree'

Plug 'editorconfig/editorconfig-vim'

Plug 'prabirshrestha/vim-lsp'

call plug#end()

" Plugin Settings
" ===============

" Set colorscheme
" ---------------
colorscheme bionik

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

" vim-lsp settings
" -----------------
" general
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_async_completion = 1

" keep it disabed, kinda buggy atm
"let g:lsp_highlight_references_enabled = 1

" when lsp in use; change key bindings
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    setlocal completeopt-=preview
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    " refer to doc to add more commands
endfunction
augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"lsp setup for python using python-language-server
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'allowlist': ['python'],
                \ })
endif

" "lsp setup for c/cpp/objc using ccls
" if executable('ccls')
"     " should be packaged in most package repositories under the name ccls
"     " a compile_commands.json file should be found in the root folder!
"     au User lsp_setup call lsp#register_server({
"                 \ 'name': 'ccls',
"                 \ 'cmd': {server_info->['ccls']},
"                 \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
"                 \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }},
"                 \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
"                 \ })
" endif

if executable('clangd')
    " included with clang
    au User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->['clangd', '-background-index']},
                \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                \ })
endif

if executable('rls')
    " install via rustup; see rls github page for details
    au User lsp_setup call lsp#register_server({
                \ 'name': 'rls',
                \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
                \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
                \ 'whitelist': ['rust'],
                \ })
endif

"lsp setup for vimlang
if executable('vim-language-server')
    augroup LspVim
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'vim-language-server',
                    \ 'cmd': {server_info->['vim-language-server', '--stdio']},
                    \ 'whitelist': ['vim'],
                    \ 'initialization_options': {
                    \   'vimruntime': $VIMRUNTIME,
                    \   'runtimepath': &rtp,
                    \ }})
    augroup END
endif

" My GUI Settings
" ===========
set guifont=Mononoki:h12
set linespace=2  " linespace is specifically set for mononoki

