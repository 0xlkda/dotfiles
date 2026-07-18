local function foldexpr_markdown(lnum)
  local l1 = vim.fn.getline(lnum)
  if l1:match("^%s*$") then
    return "="
  end
  local l2 = vim.fn.getline(lnum + 1)
  if l2:match("^=+%s*$") then
    return ">1"
  elseif l2:match("^-+%s*$") then
    return ">2"
  elseif l1:match("^#") then
    return ">" .. #l1:match("^#+")
  else
    return "="
  end
end

_G.foldexpr_markdown = foldexpr_markdown

vim.wo.foldexpr = "v:lua.foldexpr_markdown(v:lnum)"
vim.wo.foldmethod = "expr"
vim.opt_local.foldenable = true
vim.wo.foldcolumn = "0"
vim.wo.foldtext = "getline(v:foldstart).':  '.(v:foldend-v:foldstart).'  lines'"
