" Remap VIM 0 to first non-blank character
nnoremap 0 ^
nnoremap ^ 0

" Move line using alt+jk
nnoremap <M-j> :m +1<CR>==
nnoremap <M-k> :m -2<CR>==
inoremap <M-j> <Esc>:m +1<CR>==gi
inoremap <M-k> <Esc>:m -2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" Insert new line and stay in normal mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Comment code
"vmap <silent> <C-_> <plug>NERDCommenterToggle
"nmap <silent> <C-_> <plug>NERDCommenterToggle

" Insert mode navigation
inoremap <M-e> <C-o>$
inoremap <M-a> <C-o>^

" Keybinds for splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Keybinds for resizing splits
noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" Keybind for creating tabs, and vertical splits
map <silent> <A-v> :vsp<CR>

" Save and Quit keybind
noremap <silent> <leader>bd :bd<CR>
noremap <silent> <leader>q :q<CR>
noremap <silent> <leader>w :w!<CR>
inoremap <silent> <C-s> <C-o>:w!<CR>

" Y yanks from cursor to line end
nnoremap Y y$

" Keybind for fuzzy finder
nnoremap <silent> <leader>a :Files<CR>
nnoremap <silent> <leader>v :Rg<CR>
nnoremap <silent> <leader>l :BLines<CR>

" Keybind for switching buffers
nmap <silent> <tab> :bnext<CR>
nmap <silent> <S-tab> :bprev<CR>

" Delete and put text without putting it onto the register
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

" Make ci( work like in ci"
function! New_cib()
    if search("(","bn") == line(".")
        sil exe "normal! f)ci("
        sil exe "normal! l"
        startinsert
    else
        sil exe "normal! f(ci("
        sil exe "normal! l"
        startinsert
    endif
endfunction


" And also for curly brackets
function! New_ciB()
    if search("{","bn") == line(".")
        sil exe "normal! f}ci{"
        sil exe "normal! l"
        startinsert
    else
        sil exe "normal! f{ci{"
        sil exe "normal! l"
        startinsert
    endif
endfunction

nnoremap ci( :call New_cib()<CR>
nnoremap ci{ :call New_ciB()<CR>

" Alt-m for creating a new line in insert mode
imap <M-m> <esc>o

" Reload a file
nmap <F5> :e!<CR>

" Search for variables
nmap <M-f> :BTags<CR>
