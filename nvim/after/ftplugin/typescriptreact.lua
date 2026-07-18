vim.cmd("iabbrev #b /*******************************************************************************")
vim.cmd("iabbrev #e ****************************************************************************/")

require("config.folding").setup()

local group = vim.api.nvim_create_augroup("ft_tsx_mkview", { clear = true })
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = group,
  pattern = "*.tsx",
  command = "mkview",
})
