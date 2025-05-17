function! MyFold()
  let startLine = getline(v:foldstart)
  let endLine = substitute(getline(v:foldend), '\s\+\([})\]]\)', '\1', '')
  return startLine . ' ... ' . endLine
endfunction

"-- FOLDING --  
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()
set foldtext=MyFold()
set foldcolumn=0 "defines 1 col at window left, to indicate folding  
set foldlevelstart=-1 "start file with all folds opened

hi Folded guifg=none guibg=none

au! BufWinLeave *.conf mkview
au! BufEnter *.conf :TSEnable highlight indent
au! BufWritePost nginx.conf :!nginx.test && nginx.restart
