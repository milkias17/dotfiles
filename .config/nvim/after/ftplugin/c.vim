setlocal noexpandtab
augroup c
    autocmd!
    autocmd BufWritePre *.c :%s/\s\+$//e
augroup END
