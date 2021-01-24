" Set leader key
let mapleader = ","

" Copy/Paste b/n vim and other programs
set clipboard=unnamedplus

" Remap ESC to ii
imap jj <Esc>

" Height of command bar
set cmdheight=1

" Make the keyboard fast
set timeout timeoutlen=500 ttimeoutlen=50

" Make vim think of - separated words as a single word
set iskeyword+=-

" Hide buffers instead of closing them
set hidden

" Show line numbers
set number

" Show line numbers relative to current line
set relativenumber

" Blink cursor on error instead of beeping
set visualbell

" Shorten status line
set laststatus=2

" Turn on syntax highlighting
syntax on

" Highlight current line
set cursorline

" Dont show current mode
set noshowmode

" Set autoindenting to on
set autoindent

" Set Vi compatibility to false
set nocompatible

" Number of visual spaces per tab
set tabstop=4

" Let backspace delete indent
set softtabstop=4

" Expands tabs into spaces
set expandtab
set smarttab

" Shift lines by 4 spaces
set shiftwidth=4

" Make search case-insensitive when all characters are lowercase
" and make search case-sensitive when string contains uppercase letters.
set ignorecase
set smartcase

" Highlight matching pairs of brackets.
set matchpairs+=<:>

" Set encoding 
set encoding=utf-8

" Make vim indent based on filetype
filetype plugin indent on

set history=200 " keep 200 lines of command line history

 " Get better auto indent
set smartindent

 " No vim.swap file
set noswapfile

 " No backup needed
set nobackup
set nowritebackup

 " Set Undo directory and make an undo file
set undodir=~/.nvim/undodir
set undofile 

" Enable search as you type instead of waiting for results
set incsearch

" Disable highlight search
set nohlsearch

" Sane defaults to backspace key
set backspace=indent,eol,start

" Don't redraw makes executing macros faster
set lazyredraw
 
" Enable mouse support
set mouse=a

" Show matching braces
set showmatch
" how many tenth of a second to blink when matching braces
set mat=2

" Always show at least eight line above/below cursor
set scrolloff=8

" more natural vim plitting
set splitbelow
set splitright

" enable gui colors
set termguicolors

" Line break on 500 characters
set lbr
set tw=500

" Wrap lines
set wrap

" Allow backspace, space, and arrow keys to wrap lines
set whichwrap=b,s,<,>,[,]

" Shell to fish
set shell=/bin/fish

" Setup i3 config file detection for syntax highlighting
aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end

" Auto read file when changed from outside
set autoread
au FocusGained,BufEnter * checktime

" Unix as standard file type
set ffs=unix,dos,mac

" Return to last edit position when opening files 
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Setup path
set path=.,**

" Fold settings
set nofoldenable

"Setup hide all functionality
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
        :AirlineToggle
    else
        let s:hidden_all = 0
        set laststatus=2
        set showcmd
        :AirlineToggle
    endif
endfunction

nnoremap <silent> <S-h> :call ToggleHiddenAll()<CR>

" Auto Save
"autocmd TextChanged,TextChangedI <buffer> silent write
