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

" Indent and dev
syntax on
set smartindent
set autoindent
set shiftwidth=3
filetype on
set showmatch
set mat=4
set smarttab
set expandtab ts=3 sw=3 ai
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
" :set spell

" Show line number
set number
highlight LineNr term=bold ctermfg=darkgray guifg=darkgray

" Show when a line exceeds 80 chars
let s:activatedh = 0 
function! ToggleH()
    if s:activatedh == 0
        let s:activatedh = 1 
        match ErrorMsg '\%>80v.\+'
    else
        let s:activatedh = 0 
        match none
    endif
endfunction
nnoremap <F8> :call ToggleH()<CR>
call ToggleH()

function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction
nnoremap <F9> :call GotoJump()<CR>

" Highlight trailing Tabs and Spaces
highlight Tab ctermbg=darkgray guibg=darkgray
highlight Space ctermbg=darkblue guibg=darkblue
au BufWinEnter * let w:m2=matchadd('Tab', '\t', -1)
au BufWinEnter * let w:m3=matchadd('Space', '\s\+$\| \+\ze\t', -1)

" Use 256 colors
set t_Co=256

" Allow mouse
" set mouse=a

" Misc
set wildmode=longest,list,full
set wildmenu
set showcmd

" Folding
set foldmethod=syntax

" Modeline
ab MODELINE vim: set ts=3 sw=3 ai ff=unix
" set modeline
