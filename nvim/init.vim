call plug#begin()

Plug 'gruvbox-community/gruvbox'

" misc
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'AndrewRadev/tagalong.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'

" code hi-lighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" code formatter
Plug 'sbdchd/neoformat'

call plug#end()

" load my lua config
lua << EOF
require("thealemazing")
EOF

let loaded_matchparen = 1
let mapleader = " "

" useful keymaps
inoremap <C-c> <Esc>
nnoremap <C-p> :lua require('thealemazing.telescope').project_files()<CR>
nnoremap <leader>df :lua require('thealemazing.telescope').dotfiles()<CR>
nnoremap <leader>no :lua require('thealemazing.telescope').notes()<CR>
nnoremap <leader>ls :Telescope live_grep<CR>
nnoremap <leader>lb :Telescope buffers<CR>
nnoremap <leader>lf :Telescope file_browser<CR>
nnoremap <leader>ld :Telescope lsp_document_diagnostics<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader><CR> :so ~/projects/dotfiles/nvim/init.vim<CR>
vnoremap < <gv
vnoremap > >gv

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" quick paste from register +
nnoremap <leader>p "+p

" quick copy to register +
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" quick moving line around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" sync with tmux splitting
nnoremap <C-w>" :split<CR>
nnoremap <C-w>% :vsplit<CR>

" emmet
let g:user_emmet_leader_key = ','

" change tag in pairs
let g:tagalong_additional_filetypes = ['javascript']

" helper functions
fun! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" debug highlight syntax group
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

augroup THE_ALEMAZING
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace() | Neoformat
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal commentstring={/*\ %s\ */}
augroup END
