require('compe').setup {
    enabled = true;
    autocomplete = true;
    documentation = true;

    source = {
        nvim_lsp = true;
        buffer = true;
        nvim_lua = true;
    };
}
