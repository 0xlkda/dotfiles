nmap gq <ESC>:%d<CR>:r !pg_format % --spaces 2 --function-case 2<CR>
vmap gq <ESC>:'<,'>!pg_format --spaces 2 --function-case 2<CR>

lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
