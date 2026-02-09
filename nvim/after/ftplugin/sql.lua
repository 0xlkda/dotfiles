vim.keymap.set("n", "gq", "<ESC>:%d<CR>:r !pg_format % --spaces 2 --function-case 2<CR>", { buffer = true })
vim.keymap.set("v", "gq", "<ESC>:'<,'>!pg_format --spaces 2 --function-case 2<CR>", { buffer = true })

require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
