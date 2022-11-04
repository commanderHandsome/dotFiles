set nocompatible              " be iMproved

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" plugin on GitHub repo
Plug 'tpope/vim-fugitive'


" Typescript + JS + React
Plug 'kevinoid/vim-jsonc'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" plugin from http://vim-scripts.org/vim/scripts.html
"Plug 'L9'
Plug 'vim-test/vim-test'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'kien/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'

" Initialize plugin system: All of your Plugins must be added before the following line
call plug#end()

" Use new regular expression engine
set re=0

" use smyck colorscheme
" colors smyck
let mapleader = ','


" default vim-test config:  these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

"""""""""""""""""  typescript config """""""""""""""""""""""""""""""""

let g:coc_global_extensions = ['coc-tsserver', 'coc-pyright']

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

nmap <leader>do <Plug>(coc-codeaction)
nmap <leader>rn <Plug>(coc-rename)
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

" show documentation for the word under the cursor
nnoremap <silent> K :call CocAction('doHover')<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" automatic show documentation or diagnostic if it exists for the element
" under the cursor
"function! ShowDocIfNoDiagnostic(timer_id)
  "if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    "silent call CocActionAsync('doHover')
  "endif
"endfunction

"function! s:show_hover_doc()
  "call timer_start(100, 'ShowDocIfNoDiagnostic')
"endfunction

"autocmd CursorHoldI * :call <SID>show_hover_doc()
"autocmd CursorHold * :call <SID>show_hover_doc()
"
"
" vim test
autocmd FileType typescriptreact nmap <silent> t<C-n> :TestNearest --env=jest-environment-jsdom-global --watchAll=false<CR>
autocmd FileType typescriptreact nmap <silent> t<C-f> :TestFile --env=jest-environment-jsdom-global --watchAll=false<CR>
autocmd FileType typescriptreact  nmap <silent> t<C-s> :TestSuite --env=jest-environment-jsdom-global --watchAll=false<CR>
autocmd FileType typescriptreact  nmap <silent> t<C-l> :TestLast --env=jest-environment-jsdom-global --watchAll=false<CR>
autocmd FileType typescriptreact  nmap <silent> t<C-g> :TestVisit --env=jest-environment-jsdom-global --watchAll=false<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""" python """"""""""""""""""""""""""""""""""""""""""""
autocmd FileType python nmap <silent> t<C-n> :TestNearest --format=documentation<CR>
autocmd FileType python nmap <silent> t<C-f> :TestFile --format=documentation<CR>
autocmd FileType python nmap <silent> t<C-s> :TestSuite --format=documentation<CR>
autocmd FileType python nmap <silent> t<C-l> :TestLast --format=documentation<CR>
autocmd FileType python nmap <silent> t<C-g> :TestVisit --format=documentation<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


syntax on
filetype on
filetype indent on
filetype plugin on
set nowrap
set nocursorline
set hlsearch
set number


" Comment/uncomment lines
map <leader>/ <plug>NERDCommenterToggle

" powerline won't come up until you make a split unless
set laststatus=2

" enable code folding
set foldmethod=syntax
set foldlevelstart=10

set autoread
set smartcase
set history=1024
set showmatch
set list " Show whitespace
set listchars=trail:.
set expandtab " Use soft tabs
set tabstop=2 " Tab settings
set autoindent
set smarttab " Use shiftwidth to tab at line beginning
set shiftwidth=2 " Width of autoindent
set visualbell "suppress audio bell on error
set encoding=utf-8
scriptencoding utf-8
set backspace=indent,eol,start " Let backspace work over anything.

" Write all writeable buffers when changing buffers or losing focus.
set autowriteall " Save when doing various buffer-switching things.
autocmd BufLeave,FocusLost * silent! wall " Save anytime we leave a buffer or MacVim loses focus.


set incsearch " Incremental search
set swapfile
set directory=~/.vim-tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/tmp,/var/tmp,/tmp

" make the sign column the same background as the linenumber column
highlight clear SignColumn

