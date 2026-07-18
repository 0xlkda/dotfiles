local api = {}
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local utils = require('telescope.utils')

function api.change_directory(path)
  path = path or '~/code'
  local cmd = { vim.o.shell, '-c', "fd . -td " .. path }
  local directories = utils.get_os_command_output(cmd)
  local theme = themes.get_dropdown()
  local opts = vim.tbl_deep_extend("force", {}, theme or {})

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

-- respect folding: https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-864530935
local function restore_folds_after_select(prompt_bufnr)
  actions.select_default(prompt_bufnr)
  vim.schedule(function()
    vim.wo.foldmethod = vim.wo.foldmethod or "indent"
    vim.cmd("normal! zx")
    vim.cmd("normal! zz")
    pcall(vim.cmd, "loadview")
  end)
end

local find_files_opts = {
  hidden = true,
  attach_mappings = function(_, map)
    map("i", "<cr>", restore_folds_after_select)
    map("n", "<cr>", restore_folds_after_select)
    return true
  end,
}

api.my_find_files = function(opts)
  opts = opts or {}
  return builtin.find_files(vim.tbl_extend("error", find_files_opts, opts))
end


return api
