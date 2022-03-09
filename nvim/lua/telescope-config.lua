-- Telescope
local actions = require "telescope.actions"
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

require "telescope".setup {
  defaults = {
    buffer_previewer_maker = previewSmallFileOnly,
    mappings = {
      i = {
        ["<ESC>"] = actions.close,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-d>"] = actions.preview_scrolling_up,
      }
    }
  },

  extensions = {
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    },

    tmuxinator = {
      select_action = "switch", -- | "stop" | "kill"
      stop_action = "stop", -- | "kill"
      disable_icons = false,
    },
  }
}

require "telescope".load_extension("fzy_native")
require "telescope".load_extension("buffer_lines")
require "telescope".load_extension("tmuxinator")

local function set_key (key, action)
  vim.api.nvim_set_keymap("n", key, action, { noremap = true, silent = true })
end

-- Project Files selectors
set_key("<space>p", "<CMD>lua GetProjectFiles()<CR>")

function GetProjectFiles()
  local opts = require('telescope.themes').get_ivy {
    layout_config = {
      preview_width = 60,
      preview_cutoff = 1
    }
  }

  local ok = pcall(require "telescope.builtin".git_files, opts)
  if not ok then require "telescope.builtin".find_files(opts) end
end

-- Tmuxinator selector
set_key("<C-\\>", "<CMD>lua GetTmuxProjects()<CR>")

function GetTmuxProjects()
  local theme = require 'telescope.themes'.get_dropdown()
  require 'telescope'.extensions.tmuxinator.projects(theme)
end
