-- Config modules
require "globals"

local settings = require "settings"
local keymappings = require "keymappings"
local plugins = require "plugins"

-- Bootstrap
settings.load()
keymappings.load()
plugins.load()

-- Theme
vim.g.gruvbox_invert_selection = false
vim.cmd('colorscheme gruvbox')
vim.cmd('au VimEnter * hi Normal guibg=None')

-- Treesitter
require "nvim-treesitter.configs".setup {
  indent = { enable = false },
  highlight = {
		enable = true,
		additional_vim_regex_highlighting = true
	},
}

-- JSX
vim.g.vim_jsx_pretty_disable_js = 1
