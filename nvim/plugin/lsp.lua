local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
    return
end

local keys_util = require("mappings.util")
local buf_nnoremap = keys_util.buf_nnoremap
local buf_inoremap = keys_util.buf_inoremap

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "tsserver" }
})

local augroup_format = vim.api.nvim_create_augroup("my_lsp_format", { clear = true })
local autocmd_format = function(async, filter)
    vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = 0,
        callback = function()
            vim.lsp.buf.format { async = async, filter = filter }
        end,
    })
end

local default_meta_table = { __index = function() return function() end end }
local filetype_attach = setmetatable({
    scss = function()
        autocmd_format(false)
    end,

    css = function()
        autocmd_format(false)
    end,

    typescript = function()
        autocmd_format(false, function(clients)
            return vim.tbl_filter(function(client)
                return client.name ~= "tsserver"
            end, clients)
        end)
    end
}, default_meta_table)

local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local custom_attach = function(client)
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    buf_inoremap { "<C-s>", vim.lsp.buf.signature_help }

    buf_nnoremap { "<leader>rr", "LspRestart" }
    buf_nnoremap { "<leader>rn", vim.lsp.buf.rename }
    buf_nnoremap { "<leader>ca", vim.lsp.buf.code_action }

    buf_nnoremap { "gd", vim.lsp.buf.definition }
    buf_nnoremap { "gD", vim.lsp.buf.declaration }
    buf_nnoremap { "gT", vim.lsp.buf.type_definition }

    if filetype ~= "lua" then
        buf_nnoremap { "K", vim.lsp.buf.hover, { desc = "lsp:hover" } }
    end

    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.cmd [[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]]
    end

    -- Attach any filetype specific options to the client
    filetype_attach[filetype]()
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)

local servers = {
    tsserver = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
        on_attach = function(client)
            custom_attach(client)
        end,
    },
    sumneko_lua = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        -- vim
                        "vim",

                        -- Busted
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        "teardown",
                        "pending",
                        "clear",

                        -- Colorbuddy
                        "Color",
                        "c",
                        "Group",
                        "g",
                        "s",

                        -- Custom
                        "RELOAD",
                    },
                },

                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        },
    }
}

local setup_server = function(server, config)
    if not config then
        return
    end

    if type(config) ~= "table" then
        config = {}
    end

    config = vim.tbl_deep_extend("force", {
        on_init = custom_init,
        on_attach = custom_attach,
        capabilities = updated_capabilities,
        flags = {
            debounce_text_changes = nil,
        },
    }, config)

    lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
    setup_server(server, config)
end
