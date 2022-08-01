local cmd = vim.cmd
local mappings = {}
local get_ivy_theme = require('telescope.themes').get_ivy
local default_ivy_theme_config = { sorting_strategy = 'ascending', prompt_position = 'bottom' }

mappings.reload_current_buffer = function()
    cmd('luafile $MYVIMRC')
    cmd('lua print "buffer reloaded!"')
end

mappings.find_files = function()
    local opt = get_ivy_theme(default_ivy_theme_config)
    require('telescope.builtin').find_files(opt)
end

mappings.current_buffer_search = function()
    local opt = get_ivy_theme(default_ivy_theme_config)
    require('telescope.builtin').current_buffer_fuzzy_find(opt)
end

return mappings 
