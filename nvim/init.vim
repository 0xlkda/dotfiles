call plug#begin()

Plug 'gruvbox-community/gruvbox'

" misc
Plug 'mbbill/undotree'

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
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <leader>ls :Telescope live_grep<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader><CR> :so ~/projects/dotfiles/nvim/init.vim<CR>
vnoremap < <gv
vnoremap > >gv

" quick paste from register +
nnoremap <leader>p "+p

" quick copy to register +
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" quick moving line around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

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

augroup THE_ALEMAZING
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
