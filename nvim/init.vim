call plug#begin()

Plug 'gruvbox-community/gruvbox'

" misc
Plug 'mbbill/undotree'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" formatter
Plug 'sbdchd/neoformat'

call plug#end()

let loaded_matchparen = 1
let mapleader = " "

" useful keymaps
inoremap <C-c> <Esc>
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader><CR> :so ~/projects/dotfiles/nvim/init.vim<CR>

" quick paste from register +
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" quick copy to register +
vnoremap <leader>y "+y
nnoremap <leader>y "+y
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
