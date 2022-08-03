local mappings = {}

mappings.reload_vimrc = function()
    vim.cmd('luafile $MYVIMRC')
    vim.cmd('lua print "vimrc reloaded!"')
end

mappings.reload_buffer = function()
    vim.cmd('source %')
    vim.cmd('lua print "buffer reloaded!"')
end

return mappings
