if not pcall(require, "nvim-treesitter") then
    return
end

require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "go",
        "html",
        "javascript",
        "json",
        "markdown",
        "python",
        "query",
        "rust",
        "toml",
        "tsx",
        "typescript",
    },

    indent = {
        enable = true,
    },

    highlight = {
        enable = true,
        use_languagetree = false,
    },

    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },

        smart_rename = {
            enable = false,
            keymaps = {
                -- mapping to rename reference under cursor
                smart_rename = "grr",
            },
        },

        navigation = {
            enable = false,
            keymaps = {
                goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
                list_definitions = "gnD", -- mapping to list all definitions in current file
            },
        },
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
            node_incremental = "<M-w>", -- increment to the upper named parent
            node_decremental = "<M-C-w>", -- decrement to the previous node
            scope_incremental = "<M-e>", -- increment to the upper scope (as defined in locals.scm)
        },
    },

    context_commentstring = {
        enable = true,

        -- With Comment.nvim, we don't need to run this on the autocmd.
        -- Only run it in pre-hook
        enable_autocmd = false,

        config = {
            c = "// %s",
            lua = "-- %s",
        },
    },

    textobjects = {
        move = {
            enable = true,
            set_jumps = true,

            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]p"] = "@parameter.inner",
                ["]c"] = "@conditional.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[p"] = "@parameter.inner",
                ["[c"] = "@conditional.outer",
            },
        },

        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",

                ["ac"] = "@conditional.outer",
                ["ic"] = "@conditional.inner",

                ["ap"] = "@parameter.outer",
                ["ip"] = "@parameter.inner",

                ["av"] = "@variable.outer",
                ["iv"] = "@variable.inner",
            },
        },
    },

    playground = {
        enable = true,
        updatetime = 25,
        persist_queries = true,
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",

            -- This shows stuff like literal strings, commas, etc.
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
}
