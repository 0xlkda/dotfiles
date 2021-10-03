-- Config modules
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
