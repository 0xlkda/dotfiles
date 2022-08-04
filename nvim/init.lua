require('globals')
if require('first_load').check() then
    return
end

vim.g.mapleader = ' '

-- Use filetype.lua instead of filetype.vim (faster startup)
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

require('package_manager').setup(function(use)
    -- Common
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'rose-pine/neovim'
    use 'mbbill/undotree'
    use 'nvim-telescope/telescope.nvim'

    -- LSP
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'onsails/lspkind.nvim'

    -- Treesitter
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- Javascript
    
    -- Snippets
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'

    -- Autocomplete
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'

    -- Misc
    use 'numToStr/Comment.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use {
        'tpope/vim-scriptease',
        cmd = {
            'Messages', --view messages in quickfix list
            'Verbose', -- view verbose output in preview window.
            'Time', -- measure how long it takes to run some stuff.
        },
    }
end)

require('disable_builtin')
