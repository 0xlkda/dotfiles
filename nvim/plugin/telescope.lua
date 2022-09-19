if not pcall(require, "telescope") then
    print "telescope.nvim not found"
    return
end

local action_layout = require "telescope.actions.layout"
local previewers = require "telescope.previewers"

local previewSmallFileOnly = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require("telescope").setup {
    defaults = {
        buffer_previewer_maker = previewSmallFileOnly,
        mappings = {
            i = {
                ["<C-x>"] =  false,
                ["<M-p>"] = action_layout.toggle_preview,
                ["<M-m>"] = action_layout.toggle_mirror,
            },
        }
    }
}

local keymap = require("utils.keymap")
local nmap = keymap.nmap
local imap = keymap.imap
local api = require('api.telescope')

imap({ '<C-c>', '<esc>' })
nmap({ '<Leader>dd', api.diagnostics })
nmap({ '<Leader>h', api.vim_help_tags })
nmap({ '<Leader>b', api.list_buffers })
nmap({ '<Leader>f', api.live_search })
nmap({ '<C-f>', api.current_buffer_search })
nmap({ '<C-p>', api.find_files })
nmap({ '<C-g>', api.change_project })
