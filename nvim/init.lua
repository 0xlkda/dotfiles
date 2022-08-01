local set = vim.opt
local global = vim.g
local setkey = vim.keymap.set
local plugins = require('plugins')
local mappings = require('mappings')

global.mapleader = ' '
set.background = 'light'
set.clipboard = 'unnamedplus'
set.guicursor = ''
set.number = true
set.relativenumber = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.hlsearch = true
set.incsearch = true
set.smartindent = true
set.wrap = false

plugins.setup(function(use)
    use 'wbthomason/packer.nvim'
    use 'rose-pine/neovim'
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim' end)

setkey('i', '<C-c>', '<esc>')
setkey('n', '<Leader><CR>', mappings.reload_current_buffer)
setkey('n', '<Leader>f', mappings.current_buffer_search)
setkey('n', '<C-p>', mappings.find_files)
