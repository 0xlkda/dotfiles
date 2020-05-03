" Better typing course
set nocompatible

" VimPlug setup
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'dracula/vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-cheat40'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Environments
syntax enable
color dracula
filetype on
filetype plugin on
filetype indent on

if has('termguicolors') && $COLORTERM ==# 'truecolor'
  let &t_8f = "\<esc>[38;2;%lu;%lu;%lum" " Needed in tmux
  let &t_8b = "\<esc>[48;2;%lu;%lu;%lum" " Ditto
  set termguicolors
  set background=dark
endif

set number
set relativenumber
set laststatus=2
set notitle
set cmdheight=2
set shortmess+=Im
set diffopt+=vertical
set encoding=utf-8
set hidden
set updatetime=500
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set scrolloff=3

" Tab / spaces setting
set tabstop=4
set softtabstop=2
set shiftwidth=2

" Cmd popup
set wildmode=full
set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
set wildignorecase

" Editing
set backspace=indent,eol,start
set splitright
set splitbelow

" Wrapping
set whichwrap+=<,>,[,],h,l
set nowrap
set linebreak
set formatoptions+=1j
set textwidth=80

" Enable mouse
set mouse=nv
set mousefocus

" Start of default statusline
set statusline=%f\ %h%w%m%r\ 

" Set statusline+=%#warningmsg#
set statusline+=%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}
set statusline+=%*

" End of default statusline (with ruler)
set statusline+=%=%(%l,%c%V\ %=\ %P%)

" Yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
	set clipboard+=unnamedplus
  endif
endif

" Better Ctrl-g
nnoremap <C-g> 2<C-g>

" Quick resize
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

" Search and Replace
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Insert mode useful keymap
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

" Disable quote concealing in JSON files
let g:vim_json_conceal=0

" Auto turn off highlight after search
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Bye Ex Mode
map Q gq

" Auto command to save time
augroup lf_autocmds
  autocmd!

  " Resize windows when the terminal window size changes (from http://vimrcfu.com/snippet/186)
  autocmd VimResized * wincmd =

  " On opening a file, jump to the last known cursor position (see :h line())
  autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
		\   exe "normal! g`\"" |
		\ endif

  " Don't auto insert a comment when using O/o for a newline
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Automatically reload vimrc when it's saved
  autocmd BufWritePost .vimrc source %

  " Automatically reload files when changed
  autocmd FocusGained, BufEnter * :checktime 
  autocmd CursorHold,CursorHoldI * checktime
augroup END

" Use space as alternative leader
map <space> <leader>

" Move to last edit location and put it in the center of the screen
nnoremap <C-o> <C-o>zz

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" FZF config
map <C-P> :Files<CR>
map <C-F> :GFiles --cached --others --exclude-standard<CR>
map <C-B> :Buffers<CR>
map <C-H> :History<CR>

" Window management
nnoremap <leader>1 1<c-w>w
nnoremap <leader>2 2<c-w>w
nnoremap <leader>3 3<c-w>w
nnoremap <leader>4 4<c-w>w
nnoremap <leader>5 5<c-w>w
nnoremap <leader>6 6<c-w>w
nnoremap <leader>7 7<c-w>w
nnoremap <leader>8 8<c-w>w
nnoremap <leader>9 9<c-w>w
nnoremap <leader>0 10<c-w>w

" NERDTree config
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Coc config
let g:coc_global_extensions = [
	  \ 'coc-tsserver',
	  \ 'coc-css',
	  \ 'coc-json',
	  \ 'coc-html',
	  \ 'coc-pairs'
	  \ ]

" Show completion
inoremap <silent><expr> <C-space> coc#refresh()
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" GoTo code navigation.
nmap <silent> gd :<C-u>call CocActionAsync('jumpDefinition')<CR>
nmap <silent> gy :<C-u>call CocActionAsync('jumpTypeDefinition')<CR>
nmap <silent> gi :<C-u>call CocActionAsync('jumpImplementation')<CR>
nmap <silent> gr :<C-u>call CocActionAsync('jumpReferences')<CR>

" Use `[c` and `]c` for navigate diagnostics
nmap <silent>[c <Plug>(coc-diagnostic-prev)
nmap <silent>]c <Plug>(coc-diagnostic-next)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Prettier shortcut
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <silent> <leader>pf :Prettier<CR>
nmap <leader>qf  <Plug>(coc-fix-current)

" Coc-pairs
autocmd FileType markdown let b:coc_pairs_disabled = ['`']

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
