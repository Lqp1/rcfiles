" VIMRC

" Global settings
set nocompatible
set background=dark
set cursorline
set history=100
filetype plugin on
filetype indent on

" Set cursor to last known position
if has("autocmd")
     au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Encoding
set encoding=utf8
set ffs=unix,dos,mac

" Avoid conflicts; re-read changed files
set autoread

" Shortcut to sudo-save a file
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Shortcut to exit insert mode faster
inoremap jk <ESC>

" Indent and dev
syntax on
set smartindent
set autoindent
set shiftwidth=4
filetype on
set showmatch
set mat=4
set smarttab
set tabstop=4
set softtabstop=4
set expandtab

autocmd FileType make setlocal noexpandtab

" Status line
hi User1 ctermbg=124 ctermfg=white
hi User2 ctermbg=214 ctermfg=black
set laststatus=2
au InsertEnter * hi StatusLine ctermfg=70
au InsertLeave * hi StatusLine ctermfg=189
set statusline=%1*%m%*%r%h\ %2*%f%*\ [%{strlen(&fenc)?&fenc:'none'},%{&ff},%{strlen(&ft)?&ft:'none'}]%=%c,%l/%L

" Backup
set backup
set backupdir=~/.vimdat
set dir=~/.vimdat

" Search tips
set wrapscan
set hlsearch
set ignorecase
set smartcase
set incsearch

" Spelling tips
autocmd BufEnter *.txt,README,*.md set spell

" Show line number
set number relativenumber
highlight LineNr term=bold ctermfg=darkgray guifg=darkgray

" Highlight trailing Tabs and Spaces
highlight Tab ctermbg=darkgray guibg=darkgray
highlight Space ctermbg=darkblue guibg=darkblue
au BufWinEnter * let w:m2=matchadd('Tab', '\t', -1)
au BufWinEnter * let w:m3=matchadd('Space', '\s\+$\| \+\ze\t', -1)

" Highlight non ascii chars
" highlight nonAscii ctermfg=blue guifg=blue
" au BufWinEnter * let w:m4=matchadd('nonAscii', '[^\d0-\d127]', -1)

" Use 256 colors
set t_Co=256

" Allow mouse and system clipboard smoothly
" set mouse=a
" set clipboard=unnamedplus

" Misc
set wildmode=longest,list,full
set wildmenu
set path+=**
set showcmd
imap <C-d> <C-o>daw

" Folding
set foldmethod=syntax

" NetRW config
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3 

" Modeline
ab MODELINE vim: set ts=4 sw=4 ai ff=unix
" set modeline
