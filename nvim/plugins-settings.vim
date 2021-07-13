" Floaterm
let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_next   = '<F2>'
let g:floaterm_keymap_prev   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'
let g:floaterm_autoinsert=1
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

" Nvim Colorizer
lua require'colorizer'.setup()

" Rainbow Parenthesis
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

autocmd FileType * RainbowParentheses

" Airline
"
" Enable tabline
let g:airline#extensions#tabline#enabled = 1

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ' ' "''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ' ' "''

let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = ''

" " Enable powerline fonts
" let g:airline_powerline_fonts = 1
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''

" Always show tabs
set showtabline=2

" WhichKey
"nnoremap <silent> <leader> :WhichKey ','<CR>
"autocmd! FileType which_key
"autocmd  FileType which_key set laststatus=0 noshowmode noruler
  "\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
