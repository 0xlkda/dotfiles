local imap = function(tbl)
  vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

local nmap = function(tbl)
  vim.keymap.set("n", tbl[1], tbl[2], tbl[3])
end

local vmap = function(tbl)
  vim.keymap.set("v", tbl[1], tbl[2], tbl[3])
end

local telescope_mappings = require('telescope_mappings')

imap({ '<C-c>', '<esc>' })
nmap({ '<Leader><CR>', telescope_mappings.reload_vimrc })
nmap({ '<Leader>h', telescope_mappings.vim_help_tags })
nmap({ '<Leader>b', telescope_mappings.list_buffers })
nmap({ '<C-f>', telescope_mappings.current_buffer_search })
nmap({ '<C-p>', telescope_mappings.find_files })

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

