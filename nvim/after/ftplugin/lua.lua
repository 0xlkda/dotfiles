local mappings = require("mappings.me")
local keys_util = require("mappings.util")
local nmap = keys_util.nmap

nmap({ '<leader>rl', mappings.reload_buffer })
