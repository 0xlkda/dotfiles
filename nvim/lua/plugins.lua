local M = {}
local fn = vim.fn

if fn.empty(fn.glob(PACKER_INSTALL_PATH)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', PACKER_INSTALL_PATH})
  vim.cmd 'packadd packer.nvim'
end

function M.load()
  require('packer').startup(function()

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
    use 'hrsh7th/vim-vsnip-integ'
    use 'rafamadriz/friendly-snippets'

    -- Autocomplete
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/nvim-cmp'

    -- Lsp completion icons
    use 'onsails/lspkind-nvim'

    -- Code formatting
    use {
      'prettier/vim-prettier',
      run = 'pnpm install',
      ft = {
        'javascript', 'typescript',
        'javascriptreact', 'typescriptreact',
        'html', 'css', 'json',
        'graphql', 'markdown'
      }
    }

    -- Telescope
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'jeetsukumaran/telescope-buffer-lines.nvim'
    use 'danielpieper/telescope-tmuxinator.nvim'

    -- Treesitter
    use 'nvim-treesitter/nvim-treesitter'

    -- Lua
    use 'folke/lua-dev.nvim'

    -- JSX
    use 'MaxMEllon/vim-jsx-pretty'
    use 'styled-components/vim-styled-components'

    -- Status line
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'

    -- Theme
    use 'rose-pine/neovim'

  end)
end

return M
