iabbrev #b /*******************************************************************************
iabbrev #e ****************************************************************************/

function! MyFold()
  let startLine = getline(v:foldstart)
  let regex = '`{}<>()\[\]'
  let endLine = substitute(getline(v:foldend), '\s\{2,}\([' . regex . ']\)', '\1', '')
  return startLine . ' ... ' . endLine
endfunction

set foldtext=MyFold()
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()
hi Folded guifg=none guibg=none

" au InsertEnter, InsertLeave, BufWrite, BufWinLeave *.ts mkview

" javascript development mappings
map <leader>, :silent! clear<CR>:!ts-node %<CR>
map <leader>. :silent! clear<CR>:!jest %:r.spec.ts<CR>
map <leader>/ :e %:r.spec.ts<CR>
