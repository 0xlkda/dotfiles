local utils = {}

function utils.join_paths(...)
  local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
  local result = table.concat(vim.tbl_flatten { ... }, path_sep):gsub(path_sep .. "+", path_sep)
  return result
end

return utils
