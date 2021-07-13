" Autoinstall vim-plug if doesn't exist
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \ 
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.nvim/plugged/')

" ################################################# Useful Utilities ############################################################
" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary' " Commenter for vim
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Autocompletion
Plug 'voldikss/vim-floaterm' " Float Term
Plug 'norcalli/nvim-colorizer.lua' "Color highlighting
Plug 'tpope/vim-surround'
Plug 'tweekmonster/startuptime.vim'
Plug 'tpope/vim-eunuch' "Commands for UNIX shell actions
"Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-lua/completion-nvim'

" ################################################# Colorschemes ############################################################
Plug 'sickill/vim-monokai' " Monokai colorscheme
Plug 'joshdick/onedark.vim' " One dark colorscheme
Plug 'morhetz/gruvbox' " Gruvbox theme
Plug 'flazz/vim-colorschemes' " Collection of themes

" ################################################# Visual Stuff ############################################################
Plug 'sheerun/vim-polyglot' " Better syntax highlighting
Plug 'junegunn/rainbow_parentheses.vim' " Different color for parenthesis
" Status Line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine' " Show indentation
Plug 'ryanoasis/vim-devicons' " Beautiful Icons for vim

" ################################################ Cool Plugins ################################################################
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'} " Live preview 
" Plug 'shime/vim-livedown' " Live reload for markdown
call plug#end()
