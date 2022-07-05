require "common.utils"
require "common.settings"
require "common.keymap"
require "common.plugin"
require "config.telescope"
require "autocommands"
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

lspconfig.sumneko_lua.setup(require("lua-dev").setup(opts))
lspconfig.tsserver.setup(opts)
lspconfig.svelte.setup(opts)

-- Code formatting
vim.g["prettier#exec_cmd_async"] = 1
vim.g["prettier#exec_cmd_path"] = "/Users/alex/.nvm/versions/node/v14.19.1/bin/prettier"
vim.g["prettier#autoformat_require_pragma"] = 0
vim.g["prettier#autoformat_config_present"] = 1
vim.g["rustfmt_autosave"] = 1

-- Autocomplete
vim.g.vsnip_snippet_dir = "~/projects/dotfiles/nvim/vsnip"

local cmp = require "cmp"
local lspkind = require "lspkind"

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local confirmOpts = {
  behavior = cmp.ConfirmBehavior.Insert,
  select = true,
}

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
    -- Accept currently selected item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<TAB>"] = cmp.mapping.confirm(confirmOpts),
    ["<CR>"] = cmp.mapping.confirm(confirmOpts),

    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "c", "i", "s" }),

    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "c", "i", "s" }),

    ["<C-e>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),

    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-y>"] = cmp.config.disable
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
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
vim.o.fillchars = "fold:‧"
vim.g.crease_foldtext = { default = "%{repeat('‧', indent(v:foldstart))}%t %= (%l lines) %f%f%f" }

-- FIX fold not trigger when open file by telescope
vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      command = "normal! zx"
    })
  end
})
