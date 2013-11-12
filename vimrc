" VIMRC

" Global settings
:set nocompatible
:set background=dark
:set cursorline
:set history=100
:filetype plugin on
:filetype indent on

" Encoding
:set encoding=utf8
:set ffs=unix,dos,mac

" Avoid conflicts; re-read changed files
:set autoread

" Indent and dev
:syntax on
:set shiftwidth=3
:filetype on
:set showmatch
:set mat=4
:set expandtab
:set smarttab
:autocmd FileType make setlocal noexpandtab

" Status line
:set laststatus=2
:set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Search tips
:set wrapscan
:set hlsearch
:set ignorecase
:set smartcase

" Spelling tips
" :set spell

" Show line number
:set number
:highlight LineNr term=bold ctermfg=darkgray guifg=darkgray

" Show when a line exceeds 80 chars
:au BufWinEnter * let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Highlight trailing Tabs and Spaces
:highlight Tab ctermbg=darkgray guibg=darkgray
:highlight Space ctermbg=darkblue guibg=darkblue
:au BufWinEnter * let w:m2=matchadd('Tab', '\t', -1)
:au BufWinEnter * let w:m3=matchadd('Space', '\s\+$\| \+\ze\t', -1)
:set list listchars=tab:»·,trail:·
:set ts=8 sw=3 sts=8 expandtab cino=>5n-3f0^-2{2(0W1st0

