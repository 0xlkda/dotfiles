local lspconfig = require('lspconfig')

-- tsserver setup
lspconfig.tsserver.setup {
    on_attach = function(client)
        client.config.flags.allow_incremental_sync = true
        client.resolved_capabilities.document_formatting = false
    end
}
