local utils = require "telescope.utils"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local themes = require "telescope.themes"
local conf = require "telescope.config".values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_layout = require("telescope.actions.layout")
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
    layout_strategy = 'vertical',
    layout_config = {
      prompt_position = "bottom",
      width = 0.98,
      height = 0.98,
      preview_cutoff = 1,
    },
    mappings = {
      i = {
        ["<ESC>"] = actions.close,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-e>"] = actions.preview_scrolling_up,
        ["<C-f>"] = action_layout.toggle_preview
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

local normal = 'n'
local setkey = vim.keymap.set

-- Current directory files selectors
setkey(normal, "<C-p>", ":lua GetCurrentDirFiles()<CR>")
function GetCurrentDirFiles(opts)
  require "telescope.builtin".find_files(opts)
end

-- Project files selectors
setkey(normal, "<Leader>p", ":lua GetProjectFiles()<CR>")
function GetProjectFiles(opts)
  local ok = pcall(require "telescope.builtin".git_files, opts)
  if not ok then require "telescope.builtin".find_files(opts) end
end

-- Tmuxinator selector
setkey(normal, "<C-\\>", ":lua GetTmuxProjects()<CR>")
function GetTmuxProjects()
  local theme = themes.get_dropdown()
  require 'telescope'.extensions.tmuxinator.projects(theme)
end

-- Change directory
setkey(normal, "<C-g>", ":lua ChangeDirectory({ path = '~/projects' })<CR>")
function ChangeDirectory(config)
  local path = config.path or '.'
  local cmd = { vim.o.shell, '-c', "fd . -td " .. path }
  local directories = utils.get_os_command_output(cmd)
  local theme = themes.get_dropdown()
  local opts = vim.tbl_deep_extend("force", config, theme or {})

  pickers.new(opts, {
    prompt_title = "Directories",
    finder = finders.new_table({
      results = directories,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        vim.cmd("cd " .. selection)
        print(string.format("Current directory: %s", selection))
      end)
      return true
    end,
  }):find()
end
