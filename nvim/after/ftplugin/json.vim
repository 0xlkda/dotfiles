function! MyFold()
  let startLine = getline(v:foldstart)
  let endLine = substitute(getline(v:foldend), '^\s*', '', 'g')
  return startLine . ' ... ' . endLine
endfunction

set foldtext=MyFold()
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()

hi Folded guifg=none guibg=none
