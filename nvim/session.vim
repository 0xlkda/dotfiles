let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/code/hds/master-data-service/src/modules/contract-builder
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +65 libs/master-data-query/src/master-data-query.service.ts
badd +244 src/contract-builder.service.ts
badd +49751 src/constants/master.constants.ts
badd +31 src/constants/form.constants.ts
argglobal
%argdel
edit src/constants/form.constants.ts
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 27 + 20) / 40)
exe '2resize ' . ((&lines * 10 + 20) / 40)
argglobal
balt src/constants/master.constants.ts
setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=1
setlocal foldminlines=1
setlocal foldnestmax=6
setlocal foldenable
480
sil! normal! zo
481
sil! normal! zo
482
sil! normal! zo
483
sil! normal! zo
484
sil! normal! zo
488
sil! normal! zo
493
sil! normal! zo
493
sil! normal! zc
498
sil! normal! zo
499
sil! normal! zo
500
sil! normal! zo
500
sil! normal! zc
499
sil! normal! zc
498
sil! normal! zc
let s:l = 45 - ((14 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 45
normal! 044|
wincmd w
argglobal
enew
balt src/constants/master.constants.ts
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=1
setlocal foldminlines=1
setlocal foldnestmax=6
setlocal foldenable
wincmd w
exe '1resize ' . ((&lines * 27 + 20) / 40)
exe '2resize ' . ((&lines * 10 + 20) / 40)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
