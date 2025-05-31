iabbrev #b /*******************************************************************************
iabbrev #e ****************************************************************************/

let g:javascript_plugin_jsdoc = 1
let javaScript_fold = 1

function! MyFold()
  let startLine = getline(v:foldstart)
  let endLine = substitute(getline(v:foldend), '^\s*', '', 'g')
  return startLine . ' ... ' . endLine
endfunction

set foldtext=MyFold()
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()
set foldnestmax=10

hi Folded guifg=none guibg=none

au BufWinLeave *.js mkview

" javascript development mappings
map <leader>, :silent! clear<CR>:!node %<CR>
map <leader>. :silent! clear<CR>:!jest %:r.spec.js<CR>
map <leader>/ :e %:r.spec.js<CR>
