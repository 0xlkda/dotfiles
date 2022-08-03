-- https://github.dev/tjdevries/config_manager/xdg_config/nvim/lua/tj/globals.lua
local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
    Reloader = require
else
    Reloader = plenary_reload.reload_module
end

P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    return Reloader(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end


local _currentThemeMode = 'light'

function ToggleThemeLight()
    vim.cmd("set background=light")
    vim.cmd("silent !~/projects/dotfiles/alacritty/use_light_theme")
    _currentThemeMode = 'light'
end

function ToggleThemeDark()
    vim.cmd("set background=dark")
    vim.cmd("silent !~/projects/dotfiles/alacritty/use_dark_theme")
    _currentThemeMode = 'dark'
end

function ToggleTheme()
    if _currentThemeMode == 'light' then
        ToggleThemeDark()
    else
        ToggleThemeLight()
    end

    -- apply theme!
    vim.cmd("colorscheme rose-pine")

    -- refine color highlight
    local palette = require "rose-pine.palette"
    vim.cmd("hi NormalFloat guibg=" .. palette.surface .. " guifg=" .. palette.text)
end
