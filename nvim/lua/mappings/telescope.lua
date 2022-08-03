local mappings = {}
local themes = require('telescope.themes')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require "telescope.config".values
local utils = require('telescope.utils')

local default_ivy_theme_config = { sorting_strategy = 'ascending', prompt_position = 'bottom' }
local default_opt = themes.get_ivy(default_ivy_theme_config)
local builtin = require('telescope.builtin')

mappings.find_files = function()
    builtin.find_files(default_opt)
end

mappings.diagnostics = function()
    builtin.diagnostics(default_opt)
end

mappings.live_search = function()
    builtin.live_grep(default_opt)
end

mappings.current_buffer_search = function()
    builtin.current_buffer_fuzzy_find(default_opt)
end

mappings.vim_help_tags = function()
    builtin.help_tags(default_opt)
end

mappings.list_buffers = function()
    builtin.buffers(default_opt)
end

mappings.change_project = function()
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

return mappings
