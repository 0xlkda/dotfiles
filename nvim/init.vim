call plug#begin()

Plug 'gruvbox-community/gruvbox'

" misc
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'AndrewRadev/tagalong.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-fugitive'
Plug 'andymass/vim-matchup'

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

let mapleader = " "

" useful keymaps
inoremap <C-c> <Esc>
nnoremap <silent><C-p> :lua require('thealemazing.telescope').project_files()<CR>
nnoremap <silent><leader>df :lua require('thealemazing.telescope').dotfiles()<CR>
nnoremap <silent><leader>no :lua require('thealemazing.telescope').notes()<CR>
nnoremap <silent><leader>ls :Telescope live_grep<CR>
nnoremap <silent><leader>lb :Telescope buffers<CR>
nnoremap <silent><leader>lf :Telescope file_browser<CR>
nnoremap <silent><leader>ld :Telescope lsp_document_diagnostics<CR>
nnoremap <silent><leader>u :UndotreeShow<CR>
nnoremap <leader><CR> :so ~/projects/dotfiles/nvim/init.vim<CR>
vnoremap < <gv
vnoremap > >gv

" close other buffers
command Bd :up | %bd | e#
nnoremap <leader>bd :<c-u>up <bar> %bd <bar> e#<cr>

" compe mapping
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

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

" quick format
nnoremap <Leader>ff :Neoformat<CR>

" emmet
let g:user_emmet_leader_key = ','

" change tag in pairs
let g:tagalong_additional_filetypes = ['javascript', 'typescript']

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
    autocmd BufWritePre * :call TrimWhitespace()

    " Return to last edit position when opening files
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif

    " Use local package
    if isdirectory($PWD .'/node_modules')
        let $PATH .= ':' . $PWD . '/node_modules/.bin'
    endif
augroup END
