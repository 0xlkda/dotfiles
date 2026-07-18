vim.wo.foldmethod = "syntax"
vim.wo.foldcolumn = "1"
vim.wo.foldtext = "getline(v:foldstart).':  '.(v:foldend-v:foldstart).'  lines'"
