local M = {}

local ls_install_prefix = vim.fn.stdpath "data" .. "/lspinstall"

local lsp_langs = {
  javascript = {
    provider = 'tsserver',
    setup = {},
  },

  javascriptreact = {
    provider = 'tsserver',
    setup = {}
  },

  lua = {
    provider = "sumneko_lua",
    setup = {
      cmd = {
        ls_install_prefix .. "/lua/sumneko-lua-language-server",
        "-E",
        ls_install_prefix .. "/lua/main.lua",
      },
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
        },
      },
    }
  }
}

function M.common_on_attach(client, bufnr)
  local status_ok, wk = pcall(require, "which-key")
  if not status_ok then
    return
  end

  local keys = {
    ["K"]  = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
    ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
    ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
    ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto references" },
    ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
    ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "show signature help" },
    ["gp"] = { "<cmd>lua require'lsp.peek'.Peek('definition')<CR>", "Peek definition" },
    ["gl"] = { "<cmd>lua require'lsp.handlers'.show_line_diagnostics()<CR>", "Show line diagnostics" },
  }

  wk.register(keys, { mode = "n", buffer = bufnr })
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return capabilities
end

function M.setup(lang)
  local lsp = lsp_langs[lang]

  if lsp.provider ~= nil and lsp.provider ~= "" then
    local lspconfig = require "lspconfig"
    local coq = require "coq"

    if not lsp.setup.on_attach then
      lsp.setup.on_attach = M.common_on_attach
    end

    if not lsp.setup.capabilities then
      lsp.setup.capabilities = M.common_capabilities()
    end

    lspconfig[lsp.provider].setup(coq.lsp_ensure_capabilities(lsp.setup))

    -- Start COQ completion
    vim.cmd "COQnow -s"
  end
end

return M
