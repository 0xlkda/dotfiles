local M = {}

local default_options = {
	mouse = "a", -- allow the mouse to be used in neovim
	termguicolors = true, -- allow true color
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	undofile = true, -- enable persistent undo

	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	autoindent = true,
	expandtab = true,
	wrap = false,

	splitright = true,
	splitbelow = true,

	hlsearch = true, -- highlight all matches on previous search pattern
	completeopt = "menuone,preview,noselect",
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time

	cmdheight = 1, -- more space in the neovim command line for displaying messages
	showmode = false, -- we don't need to see things like -- INSERT -- anymore

	hidden = true, -- required to keep multiple buffers and open multiple buffers
	backup = false, -- no backup files
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	swapfile = false, -- creates a swapfile
}

function M.load()
	for key, value in pairs(default_options) do
		vim.opt[key] = value
	end
end

return M

