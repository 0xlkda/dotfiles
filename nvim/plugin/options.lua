local opt = vim.opt

opt.background = 'light'
opt.clipboard = 'unnamedplus'
opt.mouse = "n"
opt.guicursor = ''
opt.wrap = false
opt.belloff = "all" -- Just turn the dang bell off
opt.scrolloff = 4
opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
opt.signcolumn = "yes"

-- Cool floating window popup menu for completion on command line
opt.pumblend = 17
opt.wildmode = "longest:full"
opt.wildoptions = "pum"

opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1

opt.number = true
opt.relativenumber = true

opt.hlsearch = true
vim.cmd([[hi Search guibg=yellow]])

opt.incsearch = true
opt.showmatch = true
opt.ignorecase = true -- Ignore case when searching...
opt.smartcase = true -- ... unless there is a capital letter in the query

opt.equalalways = false
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 1000

-- Cursorline highlighting control
-- Only have it on in the active buffer
opt.cursorline = true
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

-- Tabs
opt.autoindent = true
opt.cindent = true
opt.wrap = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

opt.viewoptions = { "cursor", "folds" }
opt.foldmethod = "marker"
opt.foldlevel = 0
opt.modelines = 1

opt.inccommand = "split"
opt.swapfile = false -- Living on the edge
opt.shada = { "!", "'1000", "<50", "s10", "h" }

opt.formatoptions = opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- 2 spaces

-- set joinspaces
opt.joinspaces = false

-- set fillchars=eob:~
opt.fillchars = { eob = "~" }
