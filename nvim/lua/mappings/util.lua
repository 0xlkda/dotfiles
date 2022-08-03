local M = {}

M.imap = function(tbl)
  vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

M.nmap = function(tbl)
  vim.keymap.set("n", tbl[1], tbl[2], tbl[3])
end

M.vmap = function(tbl)
  vim.keymap.set("v", tbl[1], tbl[2], tbl[3])
end

M.buf_nnoremap = function(opts)
  opts[3] = opts[3] or {}
  opts[3].buffer = 0
  M.nmap(opts)
end

M.buf_inoremap = function(opts)
  opts[3] = opts[3] or {}
  opts[3].buffer = 0
  M.imap(opts)
end

return M
