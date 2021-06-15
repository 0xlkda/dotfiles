-- https://github.com/nanotee/nvim-lua-guide#tips-2
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

require('thealemazing.lspconfig')
require('thealemazing.telescope')
require('thealemazing.compe')
require('thealemazing.treesitter')
