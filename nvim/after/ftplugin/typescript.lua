vim.cmd("iabbrev #b /*******************************************************************************")
vim.cmd("iabbrev #e ****************************************************************************/")

require("config.folding").setup()

vim.keymap.set("n", "<leader>,", ":silent! clear<CR>:!ts-node %<CR>", { buffer = true })
vim.keymap.set("n", "<leader>.", ":silent! clear<CR>:!jest %:r.spec.ts<CR>", { buffer = true })
vim.keymap.set("n", "<leader>/", ":e %:r.spec.ts<CR>", { buffer = true })
