vim.g.mapleader = ' '

local allmodes = {'n', 'i', 'v', 't'}
local normal = 'n'
local insert = 'i'
local visual = 'v'
local term = 't'

local delkey = vim.keymap.del
local setkey = vim.keymap.set

setkey(allmodes, '<C-z>', '<nop>') -- remove C-z behaviour
setkey(normal, '<leader>w', ':write<CR>')
setkey(normal, '*', '*zz') -- center after search
setkey(normal, '<Leader>x', ':!chmod +x %<CR>') -- quick chmod +x
setkey(normal, '<C-l>', ':nohl<CR>') -- remove search highlight
setkey(normal, '<Leader>u', ':UndotreeToggle<CR>') -- show undotree

-- Telescope
setkey(normal, '<Leader>b', ':Telescope buffers<CR>')
setkey(normal, '<Leader>d', ':Telescope diagnostics<CR>')
setkey(normal, '<Leader>ca', ':Telescope lsp_code_actions<CR>')
setkey(normal, '<Leader>f', ':Telescope live_grep<CR>')
setkey(normal, '<C-f>', ':Telescope current_buffer_fuzzy_find<CR>')

-- LSP
setkey(normal, 'gd', ':Telescope lsp_definitions<CR>')
setkey(normal, 'gD', ':Telescope lsp_type_definitions<CR>')
setkey(normal, 'gr', ':Telescope lsp_references<CR>')
setkey(normal, 'gi', ':Telescope lsp_implementations<CR>')
setkey(normal, 'K', ':lua vim.lsp.buf.hover()<CR>')
setkey(normal, '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>')
setkey(normal, '<Leader>rn', ':lua vim.lsp.buf.rename()<CR>')
setkey(normal, '<Leader>q', ':lua vim.diagnostic.setloclist()<CR>')
setkey(normal, '<C-j>', ':lua vim.diagnostic.open_float()<CR>')
setkey(normal, '<C-[>', ':lua vim.diagnostic.goto_prev()<CR>')
setkey(normal, '<C-]>', ':lua vim.diagnostic.goto_next()<CR>')

-- indenting
setkey(visual, '<', '<gv')
setkey(visual, '>', '>gv')
setkey(visual, 'J', ":move '>+1<CR>gv=gv")
setkey(visual, 'K', ":move '<-2<CR>gv-gv")

-- theme
setkey(normal, '<C-PageUp>', ':lua ToggleTheme("light")<CR>')
setkey(normal, '<C-PageDown>', ':lua ToggleTheme("dark")<CR>')
