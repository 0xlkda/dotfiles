local M = {}

function M.foldtext()
  local start = vim.v.foldstart
  local line = vim.fn.getline(start)
  local end_line = vim.fn.getline(vim.v.foldend):gsub("^%s+", "")
  local bufnr = vim.api.nvim_get_current_buf()
  local row = start - 1
  local len = #line

  if len == 0 then
    return { { " ... " .. end_line, "Comment" } }
  end

  local ok_p, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok_p or not parser then
    return { { line .. " ... " .. end_line, "Folded" } }
  end

  local hl = {}
  for i = 0, len - 1 do hl[i] = "Folded" end
  parser:for_each_tree(function(tree, ltree)
    local query = vim.treesitter.query.get(ltree:lang(), "highlights")
    if not query then return end
    for id, node in query:iter_captures(tree:root(), bufnr, row, row + 1) do
      local sr, sc, er, ec = node:range()
      if sr <= row and er >= row then
        local from = (sr == row) and sc or 0
        local to = (er == row) and ec or len
        local name = "@" .. query.captures[id]
        for c = from, math.min(to, len) - 1 do hl[c] = name end
      end
    end
  end)

  local chunks = {}
  local i = 0
  while i < len do
    local h = hl[i]
    local j = i + 1
    while j < len and hl[j] == h do j = j + 1 end
    table.insert(chunks, { line:sub(i + 1, j), h })
    i = j
  end
  table.insert(chunks, { " ... " .. end_line, "Comment" })
  return chunks
end

function M.setup(opts)
  opts = opts or {}
  local method = opts.method or "expr"

  vim.wo.foldmethod = method
  if method == "expr" then
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    local bufnr = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    if ok and parser then
      parser:parse()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          pcall(vim.cmd, "silent! normal! zx")
        end
      end)
    end

    local bufnr_ins = vim.api.nvim_get_current_buf()
    local group = vim.api.nvim_create_augroup("config_folding_" .. bufnr_ins, { clear = true })
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = group,
      buffer = bufnr_ins,
      callback = function() vim.wo.foldmethod = "manual" end,
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group,
      buffer = bufnr_ins,
      callback = function()
        local ok2, p = pcall(vim.treesitter.get_parser, bufnr_ins)
        if ok2 and p then p:parse() end
        vim.wo.foldmethod = "expr"
      end,
    })
  end
  vim.wo.foldtext = "v:lua.require('config.folding').foldtext()"
  vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
end

return M
