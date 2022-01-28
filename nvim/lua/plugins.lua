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

		-- snippet
		use 'hrsh7th/cmp-vsnip'
		use 'hrsh7th/vim-vsnip'
		use 'rafamadriz/friendly-snippets'
		
		-- Autocomplete
		use 'hrsh7th/cmp-nvim-lsp'
		use 'hrsh7th/cmp-buffer'
		use 'hrsh7th/cmp-path'
		use 'hrsh7th/cmp-cmdline'
		use 'hrsh7th/nvim-cmp'

		-- Code formatting
		use {
			'prettier/vim-prettier',
			run = 'npm install',
			ft = { 'javascript', 'typescript', 'css', 'graphql', 'markdown', 'html' }
		}

    -- Telescope
    use 'nvim-telescope/telescope.nvim'
		use 'nvim-telescope/telescope-fzy-native.nvim'
		use 'jeetsukumaran/telescope-buffer-lines.nvim'
		use 'danielpieper/telescope-tmuxinator.nvim'

    -- Treesitter
    use 'nvim-treesitter/nvim-treesitter'

    -- JSX
    use 'MaxMEllon/vim-jsx-pretty'
		use 'styled-components/vim-styled-components'
		

  end) 
end

return M
