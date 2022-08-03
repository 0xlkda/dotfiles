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
    if stat.size > 1000000 then
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

local keys_util = require("mappings.util")
local nmap = keys_util.nmap
local imap = keys_util.imap
local mappings = require('mappings.telescope')

imap({ '<C-c>', '<esc>' })
nmap({ '<Leader>dd', mappings.diagnostics })
nmap({ '<Leader>h', mappings.vim_help_tags })
nmap({ '<Leader>b', mappings.list_buffers })
nmap({ '<Leader>f', mappings.live_search })
nmap({ '<C-f>', mappings.current_buffer_search })
nmap({ '<C-p>', mappings.find_files })
nmap({ '<C-g>', mappings.change_project })
