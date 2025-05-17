if &filetype ==# 'typescriptreact'
  autocmd BufEnter <buffer> ++once call TSReactEnable()
endif

function! TSReactEnable()
  if exists(':TSEnable')
    silent! TSEnable highlight
  endif
endfunction

function! MyFold()
  let startLine = getline(v:foldstart)
  let endLine = substitute(getline(v:foldend), '\s\+\([}<>)\]]\)', '\1', '')
  return startLine . ' ... ' . endLine
endfunction

"-- FOLDING --  
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()
set foldtext=MyFold()
set foldcolumn=0 "defines 1 col at window left, to indicate folding  
" let javaScript_fold=1 "activate folding by JS syntax  
set foldlevelstart=1 "start file with all folds opened

hi Folded guifg=none guibg=none

au BufWinLeave *.ts,tsx mkview
au BufEnter *.ts :TSEnable highlight

" typescript development mappings
map <leader>. :silent! clear<CR>:!ts-node %<CR>
map <leader>, :silent! clear<CR>:!jest %:r.spec.ts<CR>
map <leader>/ :e %:r.spec.ts<CR>
