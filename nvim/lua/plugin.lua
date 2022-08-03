local plugins = { }
plugins.setup = function(uses)
    require('packer').startup(uses)
end

return plugins
