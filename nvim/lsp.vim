" Setup lsp linting
lua << EOF 
require'lspconfig'.pyright.setup{}
EOF 

" Autocomplete
lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}

" Quality of life for completion
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Avoid showing message extra message when using completion
set shortmess+=c

