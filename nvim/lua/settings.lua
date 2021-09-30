local M = {}
local utils = require "utils"

M.load_settings = function ()
  local default_options = {
    mouse = "a", -- allow the mouse to be used in neovim
    updatetime = 300, -- faster completion
    timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)

    backup = false, -- no backup files
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    swapfile = false, -- creates a swapfile
    hidden = true, -- required to keep multiple buffers and open multiple buffers
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard

    cmdheight = 2, -- more space in the neovim command line for displaying messages
    showmode = false, -- we don't need to see things like -- INSERT -- anymore

    completeopt = { "menuone", "noselect" }, pumheight = 10, -- pop up menu height conceallevel = 0, -- so that `` is visible in markdown files

    fileencoding = "utf-8", -- the encoding written to a file
    foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
    foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding

    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns

    smartcase = true, -- smart case
    smartindent = true, -- make indenting smarter again

    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    termguicolors = true, -- set term gui colors (most terminals support this)

    undodir = utils.join_paths(vim.fn.stdpath "cache" , "undo"), -- set an undo directory
    undofile = true, -- enable persistent undo

    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,

    wrap = false,
  }

  for key, value in pairs(default_options) do
    vim.opt[key] = value
  end
end

return M

