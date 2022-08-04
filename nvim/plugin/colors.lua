vim.opt.background = 'light'

require('rose-pine').setup({ dark_variant = 'moon' })
vim.cmd('colorscheme rose-pine')

-- better for eyes
vim.cmd("hi Search guibg=yellow")
vim.cmd("hi DiffAdd guibg=#D4EE9F")
vim.cmd("hi DiffDelete guibg=#FFAAAA")

if vim.api.nvim_win_get_option(0, "diff") then
    vim.cmd("syntax off")
end
