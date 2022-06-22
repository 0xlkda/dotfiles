require "common.utils"
require "common.settings"
require "common.keymap"
require "common.plugin"
require "config.telescope"
require "rose-pine".setup({ dark_variant = 'moon' })

-- Theme
ToggleTheme('light')

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
require("nvim-lsp-installer").setup {}
local lspconfig = require("lspconfig")
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local opts = {
  capabilities = require 'cmp_nvim_lsp'.update_capabilities(client_capabilities)
}

lspconfig.tsserver.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
  end,
}

lspconfig.sumneko_lua.setup(require("lua-dev").setup(opts))

lspconfig.eslint.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
  end,

  settings = {
    format = { enable = false },
  }
}

-- Code formatting
vim.g["prettier#exec_cmd_async"] = 1
vim.g["prettier#exec_cmd_path"] = "/Users/alex/.nvm/versions/node/v14.19.1/bin/prettier"
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
  highlight = { enable = true },

  indent = {
    enable = true,
    disable = { "javascript" }
  },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner"
      },
    },
  },
}

-- Save cursor pos
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  command = [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]]
})

-- Code foldings
local fold_id = vim.api.nvim_create_augroup("fix:folds", { clear = true })
-- FIX folding not create for telescope_find_files: https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = fold_id,
  pattern = { "*" },
  command = "normal zx | zR",
})
-- FIX folding randomly in INSERT mode
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  group = fold_id,
  pattern = { "*" },
  command = [[ if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif ]]
})
vim.api.nvim_create_autocmd({ "InsertLeave", "WinLeave" }, {
  group = fold_id,
  pattern = { "*" },
  command = [[ if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif ]]
})
