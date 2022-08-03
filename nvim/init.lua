local globals = require('globals')
local plugin = require('plugin')

if require("first_load").check() then
  return
end

vim.g.mapleader = ' '

-- Use filetype.lua instead of filetype.vim (faster startup)
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

plugin.setup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'rose-pine/neovim'
    use 'mbbill/undotree'
    use 'neovim/nvim-lspconfig'
    use 'nvim-telescope/telescope.nvim'
end)

require("disable_builtin")
