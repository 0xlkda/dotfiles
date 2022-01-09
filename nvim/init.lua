-- Config modules
require "globals"

local settings = require "settings"
local keymappings = require "keymappings"
local plugins = require "plugins"

-- Bootstrap
settings.load() keymappings.load() plugins.load()

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

local actions = require "telescope.actions"
require "telescope".load_extension("fzy_native")
require "telescope".setup {
	defaults = {
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		mappings = {
			i = {
				["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist
			},

			n = {
				["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist
			}
		}
	},

	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
	},
}

-- JSX
vim.g.vim_jsx_pretty_disable_js = 1
