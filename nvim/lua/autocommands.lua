local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Save/restore code folds
local saveFolds = augroup("saveFolds", {})
autocmd("BufWritePost", {
  command = "silent mkview",
  group = saveFolds,
})

autocmd("BufReadPost", {
  command = "silent! loadview",
  group = saveFolds,
})

-- Format code on save for certain file types
local formatCode = augroup("formatCode", {})
autocmd("BufWritePre", {
  pattern = {
    "*.js",
    "*.md",
    "*.ts",
  },
  callback = function() vim.cmd(":Prettier<CR>") end,
  group = formatCode,
})
