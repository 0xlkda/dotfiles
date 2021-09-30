local M = {}

require('plugins').load_plugins()
require('keymappings').load_mappings()
require('settings').load_settings()

vim.cmd('colorscheme gruvbox')

