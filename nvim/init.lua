local plugins = require('plugins')
local settings = require('settings')
local mappings = require('keymappings')
local treesitter = require('treesitter')

-- Bootstrap!
plugins.load()
settings.load()
mappings.load()
treesitter.load()

-- Theme
vim.cmd('colorscheme gruvbox')

-- Auto command
vim.cmd "augroup LSP_FILETYPES"
vim.cmd "autocmd!"
vim.cmd "autocmd Filetype * lua require('filetypes').load_filetype(vim.fn.expand(\"<amatch>\"))"
vim.cmd "augroup END"
