"-- FOLDING --  
set foldmethod=syntax
set foldcolumn=1
setl foldtext=getline(v:foldstart).':\ '.(v:foldend-v:foldstart).'\ lines'
