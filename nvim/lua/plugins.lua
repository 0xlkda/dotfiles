local M = {}
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

function M.load()
  require('packer').startup(function()

    -- File explorer
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require'nvim-tree'.setup {} end
    }

    -- Comments
    use 'terrortylor/nvim-comment'

    -- Which key?
    use 'folke/which-key.nvim'

    -- Gruvbox
    use 'gruvbox-community/gruvbox'

    -- Undo history
    use 'mbbill/undotree'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'kabouzeid/nvim-lspinstall'
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- Telescope
    use 'nvim-telescope/telescope.nvim'

    -- Treesitter
    use 'nvim-treesitter/nvim-treesitter'

    -- Autocomplete
    use {
      'ms-jpq/coq_nvim',
      requires = 'ms-jpq/coq.artifacts',
    }

  end) 
end

return M
