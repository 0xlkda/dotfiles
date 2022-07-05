local set = vim.opt

set.mouse = "a"
set.clipboard = "unnamedplus"
set.expandtab = true
set.laststatus = 3
set.scrolloff = 8
set.splitright = true

-- Configure tab settings
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.shiftround = true

-- cursor line settings
set.wrap = true
set.cursorline = true
set.breakindent = true
set.linebreak = true

-- smarter search settings
set.hlsearch = false
set.ignorecase = true
set.smartcase = true

set.completeopt = "menu,menuone,noselect"
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
set.undodir = os.getenv("HOME") .. '/.config/nvim/undodir'
set.undofile = true

set.wildignore = "*/cache/*,*/tmp/*"
set.errorformat:prepend('%f|%l col %c|%m')
set.listchars = { eol = '↲', tab = '▸ ', trail = '·' }

-- Only save information about the cursor and folds on exit
set.viewoptions = { "cursor", "folds" }
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"

-- Use filetype.lua instead of filetype.vim (faster startup)
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
