function ToggleTheme(mode)
  if mode == 'light' then
    vim.cmd("set background=light")
    vim.cmd("silent !~/projects/dotfiles/alacritty/use_light_theme")
  else
    vim.cmd("set background=dark")
    vim.cmd("silent !~/projects/dotfiles/alacritty/use_dark_theme")
  end

  -- apply theme!
  vim.cmd("colorscheme rose-pine")

  -- refine color highlight
  local palette = require "rose-pine.palette"
  vim.cmd("hi NormalFloat guibg=" .. palette.surface .. " guifg=" .. palette.text)
end


