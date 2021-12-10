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
  normal_mode = "n", term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}

local keys = {
  insert_mode = {
    -- C-c as esc
    ["<C-c>"] = "<ESC>",

    -- Moving up/down when pumvisible
    ["<C-j>"] = { 'pumvisible() ? "\\<down>" : "\\<C-j>"', { expr = true, noremap = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<up>" : "\\<C-k>"', { expr = true, noremap = true } },
  },

  normal_mode = {
    -- Better window movement
    ["<C-h>"] = "<C-w>h",
    ["<C-j>"] = "<C-w>j",
    ["<C-k>"] = "<C-w>k",
    ["<C-l>"] = "<C-w>l",

    -- Toggle file explorer
    ["<Leader>e"] = ':NvimTreeToggle<CR>',

    -- Toggle undotree
    ["<Leader>u"] = ':UndotreeToggle<CR>',

    -- Telescope
    ["<C-p>"] = ':Telescope find_files<CR>',
    ["<Leader>f"] = ':Telescope find_files<CR>'
  },

  term_mode = {
  },

  visual_mode = {
    -- Better indenting
    ["<"] = "<gv",
    [">"] = ">gv",

    -- Moving lines up/down
    ["J"] = ":move '>+1<CR>gv-gv",
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
  vim.g.mapleader = ' '

  -- init!
  M.load_keys(keys)
end

return M
