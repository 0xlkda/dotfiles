vim.filetype.add({
  filename = {
    [".babelrc"] = "json",
    [".prettierrc"] = "json"
  },
})

vim.cmd([[autocmd FileType js,html,css setlocal noendofline nofixendofline]])
vim.cmd([[autocmd BufNewFile,BufRead *.js.liquid  set filetype=javascript]])

