-- Config modules
require "globals"

local settings = require "settings"
local plugins = require "plugins"
local keymappings = require "keymappings"

-- Bootstrap
settings.load()
keymappings.load()
plugins.load()

-- Save cursor pos
vim.cmd([[
" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
\  if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
\| 	exe "normal! g`\""
\| endif
]])

-- Theme
require "rose-pine".setup({
	---@usage 'main'|'moon'
	dark_variant = 'moon',
	disable_background = false,
	disable_float_background = false,
})

vim.cmd("set background=light")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("colorscheme rose-pine")
vim.cmd("nnoremap <silent> <C-PageUp> :set background=light<CR>")
vim.cmd("nnoremap <silent> <C-PageDown> :set background=dark<CR>")

-- Status line
require "lualine".setup({ options = { theme = 'rose-pine' } })

-- Diagnostic
vim.diagnostic.config({
	virtual_text = false
})

require "nvim-lsp-installer".on_server_ready(function(server)
	local opts = {}
	local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

	if server.name == "tsserver" then
		opts.capabilities = capabilities
	end

	if server.name == "sumneko_lua" then
		opts.settings = {
			Lua = {
				diagnostics = {
					globals = { 'vim', 'use' }
				}
			}
		}
	end if server.name == "eslint" then
		opts.on_attach = function (client)
			client.resolved_capabilities.document_formatting = false
		end

		opts.settings = {
			format = { enable = false },
		}
	end

	server:setup(opts)
end)

-- Code formatting
vim.g["prettier#autoformat"] = 1
vim.g["prettier#autoformat_require_pragma"] = 0

-- Autocomplete
local cmp = require "cmp"
cmp.setup {
	snippet = {
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
