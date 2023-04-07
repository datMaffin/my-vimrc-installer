let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


if has('nvim')
    call plug#begin(stdpath('data') . '/plugged')
else
    call plug#begin('~/.vim/plugged')
endif


" My stuff
Plug 'datMaffin/personal-vimrc'
Plug 'datMaffin/vim-colors-bionik'
Plug 'datMaffin/vim-colors-bionik2'

Plug 'scrooloose/nerdtree'

Plug 'editorconfig/editorconfig-vim'

Plug 'prabirshrestha/vim-lsp'

call plug#end()

" Plugin Settings
" ===============

" Personal Vimrc
" --------------
let g:use_detailed_ui = 1

" Set colorscheme
" ---------------
colorscheme bionik2

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

"lsp setup for python using python-lsp-server (maintenance fork of pyls)
if executable('pylsp')
    " pip install 'python-lsp-server[all]'
    " pip install pylsp-mypy  # mypy extension
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pylsp',
                \ 'cmd': {server_info->['pylsp']},
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

if executable('rust-analyzer')
    au User lsp_setup call lsp#register_server({
                \   'name': 'Rust Language Server',
                \   'cmd': {server_info->['rust-analyzer']},
                \   'whitelist': ['rust'],
                \ })
endif

if executable('texlab')
    " install via rustup; see rls github page for details
    au User lsp_setup call lsp#register_server({
                \ 'name': 'texlab',
                \ 'cmd': {server_info->['texlab']},
                \ 'whitelist': ['plaintex', 'tex'],
                \ })
endif

"lsp setup for ocaml
if executable('ocamllsp')
    augroup LspVim
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'ocamllsp',
                    \ 'cmd': {server_info->['ocamllsp']},
                    \ 'whitelist': ['ocaml']
                    \ })
    augroup END
endif


"lsp setup for ruby
" may need rubocop for the formatting to work
if executable('solargraph')
    augroup LspVim
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'solargraph',
                    \ 'cmd': {server_info->['solargraph', 'stdio']},
                    \ 'whitelist': ['ruby'],
                    \ 'initialization_options': {
                    \   'formatting': 'true',
                    \ }})
    augroup END
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
"set guifont=Monofoki:h10
if has("gui_running")
  " GUI is running or is about to start.
  " Set size of gvim window.
  set lines=45 columns=100
  set background=light
endif

" Windows setting
"set renderoptions=type:directx


