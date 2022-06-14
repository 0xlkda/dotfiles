require "common.utils"
require "common.settings"
require "common.keymap"
require "common.plugin"
require "config.telescope"
require "rose-pine".setup({ dark_variant = 'moon' })

-- Theme
ToggleTheme('light')

vim.cmd([[autocmd FileType js,html,css setlocal noendofline nofixendofline]])

-- Save cursor pos
vim.cmd([[
autocmd BufReadPost *
\  if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
\|  exe "normal! g`\""
\| endif
]])

-- Status line
require "lualine".setup({
  options = {
    theme = 'rose-pine',
    globalstatus = true
  }
})

-- Diagnostic
vim.diagnostic.config({ virtual_text = false })

-- LSP
require "nvim-lsp-installer".on_server_ready(function(server)
  local clientCapabilities = vim.lsp.protocol.make_client_capabilities()
  local opts = {
    capabilities = require 'cmp_nvim_lsp'.update_capabilities(clientCapabilities)
  }

  if server.name == "sumneko_lua" then
    opts = require "lua-dev".setup(opts)
  end

  if server.name == "eslint" then
    opts.on_attach = function (client)
      client.resolved_capabilities.document_formatting = false
    end

    opts.settings = {
      format = { enable = false },
    }
  end

  server:setup(opts)
end)

-- Code formatting
vim.g["prettier#exec_cmd_async"] = 1
vim.g["prettier#autoformat_require_pragma"] = 0
vim.g["prettier#autoformat_config_present"] = 1
vim.g["rustfmt_autosave"] = 1

-- Autocomplete
local cmp = require "cmp"
local lspkind = require "lspkind"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
  experimental = {
    ghost_text = true
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = {
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "c", "i", "s" }),

    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "c", "i", "s" }),

    ["<C-e>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),

    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-y>"] = cmp.config.disable,

    -- Accept currently selected item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<TAB>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "buffer" },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxWidth = 42
    })
  }
}

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  sources = {
    { name = 'path' },
    { name = 'cmdline' }
  }
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Treesitter
require "nvim-treesitter.configs".setup {
  indent = { enable = true },
  highlight = { enable = true },
}
