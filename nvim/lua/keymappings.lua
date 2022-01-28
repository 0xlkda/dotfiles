local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
	insert_mode = generic_opts_any,
	normal_mode = generic_opts_any,
	visual_mode = generic_opts_any,
	visual_block_mode = generic_opts_any,
	command_mode = generic_opts_any,
	term_mode = { silent = true },
}

local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
}

local keys = {
	insert_mode = {
		["<C-c>"] = "<ESC>",
	},

	normal_mode = {
		-- Quick chmod +x
		["<Leader>x"] = ":!chmod +x %<CR>",

		-- Keep cursor pos when indenting buffer
		["<Leader>i"] = "gg=G``zz",

		-- Quickfix navigation
		["<C-j>"] = "cprev<CR>zz",
		["<C-k>"] = "cnext<CR>zz",

		-- Toggle search highlight
		["<Leader>h"] = ":nohl<CR>",

		-- Toggle undotree
		["<Leader>u"] = ":UndotreeToggle<CR>",

		-- Telescope
		["<Leader>s"] = ":Telescope live_grep<CR>",
		["<Leader>l"] = ":Telescope buffer_lines<CR>",
		["<C-s>"] = ":Telescope current_buffer_fuzzy_find<CR>",

		-- LSP
		["gD"] = ":lua vim.lsp.buf.declaration()<CR>",
		["gd"] = ":lua vim.lsp.buf.definition()<CR>",
		["K"] = ":lua vim.lsp.buf.hover()<CR>",
		["gi"] = ":lua vim.lsp.buf.implementation()<CR>",
		["<C-k>"] = ":lua vim.lsp.buf.signature_help()<CR>",
		["<space>D"] = ":lua vim.lsp.buf.type_definition()<CR>",
		["<space>rn"] = ":lua vim.lsp.buf.rename()<CR>",
		["<space>ca"] = ":lua vim.lsp.buf.code_action()<CR>",
		["gr"] = ":lua vim.lsp.buf.references()<CR>",
		["<space>e"] = ":lua vim.diagnostic.open_float()<CR>",
		["[d"] = ":lua vim.diagnostic.goto_prev()<CR>",
		["]d"] = ":lua vim.diagnostic.goto_next()<CR>",
		["<space>q"] = ":lua vim.diagnostic.setloclist()<CR>",
		["<space>f"] = ":lua vim.lsp.buf.formatting()<CR>",
	},

	term_mode = {
	},

	visual_mode = {
		-- Better indenting
		["<"] = "<gv",
		[">"] = ">gv",

		-- Moving lines up/down
		["J"] = ":move '>+1<CR>gv=gv",
		["K"] = ":move '<-2<CR>gv-gv"
	},

	visual_block_mode = {
	},

	command_mode = {
	}
}

function M.set_keymaps(mode, key, val)
	local opt = generic_opts[mode] and generic_opts[mode] or generic_opts_any
	if type(val) == "table" then
		opt = val[2]
		val = val[1]
	end
	vim.api.nvim_set_keymap(mode, key, val, opt)
end

function M.load_mode(mode, keymaps)
	mode = mode_adapters[mode] and mode_adapters[mode] or mode
	for k, v in pairs(keymaps) do
		M.set_keymaps(mode, k, v)
	end
end

function M.load_keys(keymaps)
	for mode, mapping in pairs(keymaps) do
		M.load_mode(mode, mapping)
	end
end

function M.print(mode)
	print "List of default keymappings (not including which-key)"
	if mode then
		print(vim.inspect(keys[mode]))
	else
		print(vim.inspect(keys))
	end
end

function M.load()
	-- leader key
	vim.g.mapleader = " "

	-- init!
	M.load_keys(keys)
end

return M
