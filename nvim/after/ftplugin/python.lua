require("config.folding").setup()

vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*.py",
  command = "mkview",
})
