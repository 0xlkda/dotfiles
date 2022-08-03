local cmd = vim.cmd
local mappings = {}
local default_ivy_theme_config = { sorting_strategy = 'ascending', prompt_position = 'bottom' }
local default_opt = require('telescope.themes').get_ivy(default_ivy_theme_config)

mappings.reload_vimrc = function()
    cmd('luafile $MYVIMRC')
    cmd('lua print "vimrc reloaded!"')
end

mappings.find_files = function()
    require('telescope.builtin').find_files(default_opt)
end

mappings.current_buffer_search = function()
    require('telescope.builtin').current_buffer_fuzzy_find(opt)
end

mappings.vim_help_tags = function()
    require('telescope.builtin').help_tags(default_opt)
end

mappings.list_buffers = function()
    require('telescope.builtin').buffers(default_opt)
end

return mappings 
