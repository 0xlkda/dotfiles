vim.cmd("iabbrev #b /*******************************************************************************")
vim.cmd("iabbrev #e ****************************************************************************/")

vim.g.javascript_plugin_jsdoc = 1
vim.g.javaScript_fold = 1

require("config.folding").setup()

vim.opt_local.foldnestmax = 10

vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*.js",
  command = "mkview",
})

vim.keymap.set("n", "<leader>,", ":silent! clear<CR>:!node %<CR>", { buffer = true })
vim.keymap.set("n", "<leader>.", ":silent! clear<CR>:!jest %:r.spec.js<CR>", { buffer = true })
vim.keymap.set("n", "<leader>/", ":e %:r.spec.js<CR>", { buffer = true })
