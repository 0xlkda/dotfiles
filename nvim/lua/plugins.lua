local M = {}
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

function M.load()
  require('packer').startup(function()

    -- Gruvbox
    use 'gruvbox-community/gruvbox'

    -- Undo history
    use 'mbbill/undotree'

    -- LSP
    use 'neovim/nvim-lspconfig'
		use 'williamboman/nvim-lsp-installer'
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- Telescope
    use 'nvim-telescope/telescope.nvim'
		use 'nvim-telescope/telescope-fzy-native.nvim'

    -- Treesitter
    use 'nvim-treesitter/nvim-treesitter'

    -- JSX
    use 'MaxMEllon/vim-jsx-pretty'

  end) 
end

return M
