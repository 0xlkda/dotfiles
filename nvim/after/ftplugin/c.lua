vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("vnew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.opt_local.number = true
end, {})

vim.keymap.set("n", "<leader>,", ':redir! @o<CR>:silent !gcc -o %:r % && ./%:r<CR>:redir END<CR>:Scratch<CR>"op<C-w>p', { buffer = true })
vim.keymap.set("n", "<leader>.", ':redir! @o<CR>:!otool -tv %:r<CR>:redir END<CR>:Scratch<CR>"op<C-w>p', { buffer = true })

require("config.folding").setup({ method = "syntax" })

vim.opt_local.foldlevelstart = 1
