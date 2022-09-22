local api = {}
local themes = require 'telescope.themes'
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local utils = require('telescope.utils')
local builtin = require('telescope.builtin')

-- built-in apis
api.find_files = builtin.find_files
api.diagnostics = builtin.diagnostics
api.live_search = builtin.live_grep
api.current_buffer_search = builtin.current_buffer_fuzzy_find
api.vim_help_tags = builtin.help_tags
api.list_buffers = builtin.buffers

-- my custom apis
api.change_project = function()
    local cmd = { vim.o.shell, '-c', "fd . -td " .. '~/projects' }
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

return api
