call plug#begin('~/.nvim/plugged/')

" ################################################# Useful Utilities ############################################################
" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdcommenter' " Commenter for vim
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Autocompletion
Plug 'voldikss/vim-floaterm' " Float Term
Plug 'norcalli/nvim-colorizer.lua' "Color highlighting
Plug 'tpope/vim-surround'
Plug 'tweekmonster/startuptime.vim'

" ################################################# Colorschemes ############################################################
Plug 'sickill/vim-monokai' " Monokai colorscheme
Plug 'joshdick/onedark.vim' " One dark colorscheme
Plug 'morhetz/gruvbox' " Gruvbox theme
Plug 'flazz/vim-colorschemes' " Collection of themes

" ################################################# Visual Stuff ############################################################
Plug 'sheerun/vim-polyglot' " Better syntax highlighting
Plug 'frazrepo/vim-rainbow' " Different colors for mathcing braces
Plug 'junegunn/rainbow_parentheses.vim' " Different color for parenthesis
" Status Line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine' " Show indentation
Plug 'ryanoasis/vim-devicons' " Beautiful Icons for vim

" ################################################ Cool Plugins ################################################################
" Live preview for html/css/javascript
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
" Live reload for markdown
"Plug 'shime/vim-livedown'
" See all vim keyboard shortcuts
"Plug 'liuchengxu/vim-which-key'
"Plug 'mhinz/vim-startify' " Startup screen for vim
" Ranger integration
"Plug 'francoiscabrol/ranger.vim'
"Plug 'rbgrouleff/bclose.vim'
call plug#end()
