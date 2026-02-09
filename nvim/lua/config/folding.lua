local M = {}

function M.foldtext()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local end_line = vim.fn.getline(vim.v.foldend):gsub("^%s+", "")
  return start_line .. " ... " .. end_line
end

function M.setup(opts)
  opts = opts or {}
  local method = opts.method or "expr"

  vim.wo.foldmethod = method
  if method == "expr" then
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end
  vim.wo.foldtext = "v:lua.require('config.folding').foldtext()"
  vim.api.nvim_set_hl(0, "Folded", { fg = "NONE", bg = "NONE" })
end

return M
