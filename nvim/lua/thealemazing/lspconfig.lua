local lspconfig = require('lspconfig')

local map = function(type, key, value)
  vim.api.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true});
end

-- common
map('n','gD'         , '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n','gd'         , '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n','gr'         , '<cmd>lua vim.lsp.buf.references()<CR>')
map('n','gs'         , '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n','gi'         , '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n','gt'         , '<cmd>lua vim.lsp.buf.type_definition()<CR>')
map('n','K'          , '<cmd>lua vim.lsp.buf.hover()<CR>')

-- extras
map('n','<Space>rs', '<cmd>LspRestart<CR>')
map('n','<Space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n','<Space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n','<Space>dn' , '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n','<Space>dp' , '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n','<Space>ee' , '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
map('n','<Space>gw' , '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n','<Space>gW' , '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- rust analyzer
lspconfig.rust_analyzer.setup{
  on_attach = function(client)
    print("Rust analyzer started.");
  end,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
    }
  }
}

-- tsserver setup
lspconfig.tsserver.setup {
  on_attach = function(client)
    print("Typescript LSP started.");

    client.config.flags.allow_incremental_sync = true
    client.resolved_capabilities.document_formatting = false

  end
}

