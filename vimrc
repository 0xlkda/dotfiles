packadd! dracula
colorscheme dracula
let g:dracula_italic=0

syntax on
filetype plugin indent on

" Keep <CR> safe!
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>

set wrap
set linebreak
set encoding=utf-8 nobomb
set laststatus=2
set wildmenu
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nocompatible
set nu
set hidden
set cmdheight=2
set updatetime=300
set nobackup
set nowb
set noswapfile
set backupdir=~/tmp,/tmp
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=/tmp
set undolevels=1000
set showmode
set switchbuf=useopen,usetab
set ttyfast
set lazyredraw
set splitbelow
set splitright
set nowrap
set linebreak

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set signcolumn=yes

" make backspace work like most other programs
set backspace=2 

set autoread
set autowrite

if has('mouse')
  set mouse=a
endif

" Quick resize
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

" Quick temrinal
let g:floaterm_keymap_toggle = '<C-j>'

" insert mode useful keymap
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <silent> <C-a> <C-o>:call <SID>home()<CR>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-h> <BS>
inoremap <silent> <C-k> <C-r>=<SID>kill_line()<CR>

function! s:home()
  let start_col = col('.')
  normal! ^
  if col('.') == start_col
    normal! 0
  endif
  return ''
endfunction

function! s:kill_line()
  let [text_before_cursor, text_after_cursor] = s:split_line_text_at_cursor()
  if len(text_after_cursor) == 0
    normal! J
  else
    call setline(line('.'), text_before_cursor)
  endif
  return ''
endfunction

function! s:split_line_text_at_cursor()
  let line_text = getline(line('.'))
  let text_after_cursor  = line_text[col('.')-1 :]
  let text_before_cursor = (col('.') > 1) ? line_text[: col('.')-2] : ''
  return [text_before_cursor, text_after_cursor]
endfunction

" command line mode
cmap <C-p> <Up>
cmap <C-n> <Down>
cmap <C-b> <Left>
cmap <C-f> <Right>
cmap <C-a> <Home>
cmap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>
cnoremap <C-k> <C-f>D<C-c><C-c>:<Up>

" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" Search config
let g:indexed_search_dont_move=1
noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Search and Replace
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
vnoremap <Leader>S :s/\%V//g<Left><Left><Left>

" Disable quote concealing in JSON files
let g:vim_json_conceal=0

" Allow for typing various quit cmds while accidentally capitalizing a letter
command! -bar Q quit                      "Allow quitting using :Q
command! -bar -bang Q quit<bang>          "Allow quitting without saving using :Q!
command! -bar QA qall                     "Quit all buffers
command! -bar Qa qall                     "Quit all buffers
command! -bar -bang QA qall<bang>         "Allow quitting without saving using :Q!
command! -bar -bang Qa qall<bang>         "Allow quitting without saving using :Q!

" Quick fix open/close
nmap <silent> ,cq :cclose<CR>
nmap <silent> ,co :copen<CR>

" toggle folding with za.
" fold everything with zM
" unfold everything with zR.
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Indent a file and return cursor to current spot
map <F9> mzgg=G`z

" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv

" Better tab stop for FileType
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4

let NERDTreeShowHidden = 1
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp', '\.git', 'node_modules', 'venv', '-env', '__pycache__']
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1

autocmd BufEnter NERD_tree* :LeadingSpaceDisable
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

map <leader>f :NERDTreeFind<CR>
nmap <C-n> :NERDTreeToggle<CR>

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#f5f5f5'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_leadingSpaceEnabled = 1

" Custom status line with Coc.nvim & lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'currentfunction', 'gitbranch', 'filename', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'fileencoding', 'filetype', 'cocstatus' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \   'gitbranch': 'gitbranch#name',
      \   'filename': 'LightLineFilename'
      \ },
      \ } 

function! s:save_buffer() abort
  if empty(&buftype) && !empty(bufname(''))
    let l:savemarks = {
          \ "'[": getpos("'["),
          \ "']": getpos("']")
          \ }

    silent! update

    for [l:key, l:value] in items(l:savemarks)
      call setpos(l:key, l:value)
    endfor
  endif
endfunction

let mapleader  = ","
let g:mapleader = ","
imap <C-c> <Esc>
map <leader>r :source ~/.vimrc<CR>

map <C-P> :Files<CR>
map <C-F> :GFiles --cached --others --exclude-standard<CR>
map <C-B> :Buffers<CR>
map <C-H> :History<CR>

" Enable FZF
set rtp+=/usr/local/opt/fzf

" Coc.nvim
" Prettier shortcut
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <silent> <leader>pf :Prettier<CR>

" Coc-pairs
autocmd FileType markdown let b:coc_pairs_disabled = ['`']

" GoTo code navigation.
nmap <silent> gd :<C-u>call CocActionAsync('jumpDefinition')<CR>
nmap <silent> gy :<C-u>call CocActionAsync('jumpTypeDefinition')<CR>
nmap <silent> gi :<C-u>call CocActionAsync('jumpImplementation')<CR>
nmap <silent> gr :<C-u>call CocActionAsync('jumpReferences')<CR>

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show document
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap <silent><expr> <c-@> coc#refresh()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
