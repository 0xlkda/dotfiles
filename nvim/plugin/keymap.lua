local mappings = require("mappings.me")
local keys_util = require("mappings.util")
local nmap = keys_util.nmap
local imap = keys_util.imap
local vmap = keys_util.vmap

nmap({ '<C-r>', mappings.reload_buffer })
nmap({ '<leader><CR>', mappings.reload_vimrc })

-- Disable C-z
nmap({ '<C-z>', '<nop>' })
imap({ '<C-z>', '<nop>' })

-- Opens line below or above the current line
imap({ '<S-CR>', '<C-O>o' })

-- Move line(s) up and down
nmap({ '<C-j>', function() if vim.opt.diff:get() then vim.cmd [[normal! ]c]] else vim.cmd [[m .+1<CR>==]] end end })
nmap({ '<C-k>', function() if vim.opt.diff:get() then vim.cmd [[normal! [c]] else vim.cmd [[m .-2<CR>==]] end end })
imap({ '<C-j>', '<Esc>:m .+1<CR>==gi' })
imap({ '<C-k>', '<Esc>:m .-2<CR>==gi' })
vmap({ '<C-j>', ":m '>+1<CR>gv=gv" })
vmap({ '<C-k>', ":m '<-2<CR>gv=gv" })

-- Switch between tabs
nmap({ "<Right>", function() vim.cmd [[checktime]] vim.api.nvim_feedkeys("gt", "n", true) end })
nmap({ "<Left>", function() vim.cmd [[checktime]] vim.api.nvim_feedkeys("gT", "n", true) end })

-- theme
nmap({ '<C-\\>', ':lua ToggleTheme()<CR>' })