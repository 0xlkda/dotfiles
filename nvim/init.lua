-- Config modules
require "globals"

local settings = require "settings"
local plugins = require "plugins"
local keymappings = require "keymappings"

-- Bootstrap
settings.load()
keymappings.load()
plugins.load()

-- Theme
vim.g.gruvbox_invert_selection = false
vim.cmd("colorscheme gruvbox")
vim.cmd("au VimEnter * hi Normal guibg=None")

-- LSP
require "nvim-lsp-installer".on_server_ready(function(server)
	local opts = {}
	-- This setup() function is exactly the same as lspconfig"s setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)

-- Code formatting
vim.g["prettier#autoformat"] = 1
vim.g["prettier#autoformat_require_pragma"] = 0

-- Autocomplete
local cmp = require "cmp"
cmp.setup {
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
		{ name = "buffer" },
	})
}

-- LSP
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig")["tsserver"].setup {
	capabilities = capabilities
}

-- Treesitter
require "nvim-treesitter.configs".setup {
	indent = { enable = false },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true
	},
}

-- Telescope
require "telescope-config"
