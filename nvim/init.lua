local globals = require('globals')
local plugin = require('plugin')

if require("first_load").check() then
  return
end

vim.g.mapleader = ' '

plugin.setup(function(use)
    use 'nvim-lua/plenary.nvim'
    use 'rose-pine/neovim'
    use 'neovim/nvim-lspconfig'
    use 'wbthomason/packer.nvim'
    use 'nvim-telescope/telescope.nvim'
end)

require("disable_builtin")
