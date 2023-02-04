local neovim = {}

function neovim.plugins(use)
	use("nvim-lua/plenary.nvim")
end

function neovim.bindings(map)
	map("i", "<C-c>", "<ESC>", {})
end

function neovim.setup()
	local global = vim.g
	local opt = vim.opt

	global.mapleader = " "
	opt.clipboard = "unnamedplus"
	opt.updatetime = 100
	opt.wrap = false
	opt.scrolloff = 2
	opt.sidescrolloff = 2
	opt.number = true
	opt.relativenumber = true
	opt.signcolumn = "yes"
	opt.splitbelow = true
	opt.splitright = true
	opt.inccommand = "split"

	-- searching settings
	opt.ignorecase = true -- ignore case when searching...
	opt.smartcase = true --but be smart when I use capital letter

	-- default tab & spaces size - option 2
	opt.tabstop = 4
	opt.shiftwidth = 4
	opt.expandtab = true
end

return neovim