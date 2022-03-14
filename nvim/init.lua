-- Config modules
require "globals"

local settings = require "settings"
local plugins = require "plugins"
local keymappings = require "keymappings"

-- Bootstrap
settings.load()
keymappings.load()
plugins.load()

-- Save cursor pos
vim.cmd([[
" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
\  if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
\| 	exe "normal! g`\""
\| endif
]])

-- Theme
require "rose-pine".setup({ dark_variant = 'moon' })

function ToggleTheme(mode)
  if mode == 'light' then
    vim.cmd("set background=light")
    vim.cmd("silent !~/projects/dotfiles/alacritty/use_light_theme")
  else
    vim.cmd("set background=dark")
    vim.cmd("silent !~/projects/dotfiles/alacritty/use_dark_theme")
  end

  -- apply theme!
  vim.cmd("colorscheme rose-pine")

  -- refine color highlight
  local palette = require "rose-pine.palette"
  vim.cmd("hi NormalFloat guibg=" .. palette.surface .. " guifg=" .. palette.text)
end

ToggleTheme('light')

vim.cmd("nnoremap <silent> <C-PageUp> :lua ToggleTheme('light')<CR>")
vim.cmd("nnoremap <silent> <C-PageDown> :lua ToggleTheme('dark')<CR>")

-- Status line
require "lualine".setup({ options = { theme = 'rose-pine' } })

-- Diagnostic
vim.diagnostic.config({
  virtual_text = false
})

require "nvim-lsp-installer".on_server_ready(function(server)
  local clientCapabilities = vim.lsp.protocol.make_client_capabilities()
  local opts = {
    capabilities = require('cmp_nvim_lsp').update_capabilities(clientCapabilities)
  }

  if server.name == "sumneko_lua" then
    local library = {}
    local path = vim.split(package.path, ";")

    table.insert(path, "lua/?.lua")
    table.insert(path, "lua/?/init.lua")

    local function add(lib)
      for _, p in pairs(vim.fn.expand(lib, false, true)) do
        p = vim.loop.fs_realpath(p)
        library[p] = true
      end
    end

    -- Add required paths
    add("$VIMRUNTIME")
    add("~/.config/nvim")
    add("~/.local/share/nvim/site/pack/packer/opt/*")
    add("~/.local/share/nvim/site/pack/packer/start/*")

    opts.settings = {
      on_new_config = function(config, root)
        local libs = vim.tbl_deep_extend("force", {}, library)
        libs[root] = nil
        config.settings.Lua.workspace.library = libs
        return config
      end,

      Lua = {
        runtime = {
          version = "LuaJIT",
          path = path
        },
        diagnostics = {
          globals = { 'vim', 'use' }
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = library,
          maxPreload = 2000,
          preloadFileSize = 50000
        },
        telemetry = { enable = false }
      }
    }
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
vim.g["prettier#autoformat"] = 0
vim.g["prettier#autoformat_require_pragma"] = 0
vim.g["prettier#autoformat_config_present"] = 1

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
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),

    -- Accept currently selected item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
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
  indent = { enable = false },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
}

-- Telescope
require "telescope-config"
