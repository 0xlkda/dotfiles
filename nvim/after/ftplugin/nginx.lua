require("config.folding").setup()

vim.wo.foldcolumn = "0"
vim.wo.foldlevel = -1

vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*.conf",
  command = "mkview",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.conf",
  command = "TSEnable highlight indent",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "nginx.conf",
  command = "!nginx.test && nginx.restart",
})
