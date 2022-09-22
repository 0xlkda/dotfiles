require('aerial').setup {
    layout = {
        max_width = { 40, 0.25 }
    }
}

local keymap = require("utils.keymap")
local nmap = keymap.nmap
local imap = keymap.imap

local api = require('api.telescope-aerial')
nmap({ "<Leader>o", ":AerialToggle<Cr>" })
nmap({ '<C-f>', api.outline })
