local plugins = require('plugins')
local settings = require('settings')
local mappings = require('keymappings')
local telescope = require('core.telescope')
local treesitter = require('core.treesitter')
local which_key = require('core.which-key')
local comments = require('core.comments')

-- Bootstrap!
plugins.load()
settings.load()
mappings.load()
treesitter.load()
telescope.load()
which_key.load()
comments.load()

-- Theme
vim.cmd('colorscheme gruvbox')

-- Auto command
vim.cmd "augroup LSP_FILETYPES"
vim.cmd "autocmd!"
vim.cmd "autocmd Filetype * lua require('filetypes').load_filetype(vim.fn.expand(\"<amatch>\"))"
vim.cmd "augroup END"
