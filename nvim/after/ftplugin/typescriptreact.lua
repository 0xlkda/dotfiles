vim.cmd("iabbrev #b /*******************************************************************************")
vim.cmd("iabbrev #e ****************************************************************************/")

require("config.folding").setup()

vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*.ts",
  command = "mkview",
})
