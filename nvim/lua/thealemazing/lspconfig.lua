local lspconfig = require('lspconfig')

local map = function(type, key, value)
  vim.api.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true});
end

-- tsserver setup
lspconfig.tsserver.setup {
  on_attach = function(client)
    print("Typescript LSP started.");

    client.config.flags.allow_incremental_sync = true
    client.resolved_capabilities.document_formatting = false

    -- common
    map('n','gD'         , '<cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n','gd'         , '<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n','gr'         , '<cmd>lua vim.lsp.buf.references()<CR>')
    map('n','gs'         , '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n','gi'         , '<cmd>lua vim.lsp.buf.implementation()<CR>')
    map('n','gt'         , '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map('n','K'          , '<cmd>lua vim.lsp.buf.hover()<CR>')

    -- extras
    map('n','<leader>vrs', '<cmd>LspRestart<CR>')
    map('n','<leader>vrn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n','<leader>vca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n','<leader>dn' , '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    map('n','<leader>dp' , '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    map('n','<leader>ee' , '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    map('n','<leader>gw' , '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    map('n','<leader>gW' , '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  end
}

