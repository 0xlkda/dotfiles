local set = vim.opt

set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.wrap = false

set.splitright = true
set.splitbelow = true

set.hlsearch = true
set.completeopt = "menuone,preview,noselect"
set.relativenumber = true
set.numberwidth = 2
set.signcolumn = "yes"
set.cursorline = true

set.cmdheight = 1
set.showmode = false
set.hidden = true
set.backup = false
set.writebackup = false
set.swapfile = false

set.wildignore = "*/cache/*,*/tmp/*"
set.errorformat:prepend('%f|%l col %c|%m')
set.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
