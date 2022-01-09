local M = {}

local default_options = {
	mouse = "a", -- allow the mouse to be used in neovim
	termguicolors = true, -- set term gui colors (most terminals support this)
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	undofile = true, -- enable persistent undo

	tabstop = 2,
	shiftwidth = 2,
	wrap = false,

	hlsearch = true, -- highlight all matches on previous search pattern
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time

	cmdheight = 2, -- more space in the neovim command line for displaying messages
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

