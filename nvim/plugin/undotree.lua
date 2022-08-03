local nmap = require("me.keymap.util").nmap
local opt = vim.opt

opt.undodir = os.getenv("HOME") .. '/.config/nvim/.undodir'
opt.undofile = true

nmap({ '<leader>u', ':UndotreeToggle<CR>' })
