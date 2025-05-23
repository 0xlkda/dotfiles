vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:*',
  callback = function()
    local transition = vim.v.event.old_mode .. ":" .. vim.v.event.new_mode
    local mappings = {
      ['i:n'] = function() vim.cmd("set nocul") end,
      ['n:i'] = function() vim.cmd("set cul") end
    }

    if mappings[transition] and vim.bo.ft ~= 'TelescopePrompt'
      then mappings[transition]() end
  end,
})

-- essentials
vim.cmd([[
  let g:omni_sql_no_default_maps = 1

  colorscheme quiet 
  set updatetime=60
  set mouse=a
  set termguicolors
  set clipboard=unnamedplus
  set expandtab
  set shiftwidth=2
  set softtabstop=2

  set noshowmode
  set number
  set relativenumber
  set statusline="2"
  set signcolumn=yes

  set complete-=ti
  set incsearch
  set ignorecase
  set smartcase
  set whichwrap="b,s,<,>,h,l,[,],`"
  set grepprg="rg --vimgrep --smart-case"
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  set nowrap
  set linebreak
  set splitright

  let g:mapleader = ","
  let g:maplocalleader = ","

  nnoremap <space> za
  nnoremap <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>
  vnoremap < <gv
  vnoremap > >gv

  " folding
  set fillchars=fold:\ 
  set foldcolumn=1

  nnoremap z1f :set foldlevel=1<CR>
  nnoremap z2f :set foldlevel=2<CR>
  nnoremap z3f :set foldlevel=3<CR>
  nnoremap z4f :set foldlevel=4<CR>

  " keep cursor in place
  nnoremap J mzJ`z

  nnoremap <leader>x :silent !chmod +x %<CR>

  " moving line
  nnoremap <M-j> :m .+1<CR>==
  nnoremap <M-k> :m .-2<CR>==
  inoremap <M-j> <Esc>:m .+1<CR>==gi
  inoremap <M-k> <Esc>:m .-2<CR>==gi
  vnoremap <M-j> :m '>+1<CR>gv=gv
  vnoremap <M-k> :m '<-2<CR>gv=gv

  " diagnostics
  nnoremap <leader>q :lua vim.diagnostic.setloclist()<CR>
  nnoremap gl :lua vim.diagnostic.open_float(nil, { focus = false })<CR>
  nnoremap ]d :lua vim.diagnostic.goto_next(nil, { focus = false })<CR>
  nnoremap [d :lua vim.diagnostic.goto_prev(nil, { focus = false })<CR>

  " jumps
  nnoremap <leader>j :lprev<CR>zz
  nnoremap <leader>k :lnext<CR>zz

  " split lines
  command! -range Split '<,'>s/, /,\r/gI
  vmap ,s :Split<CR>:nohl<CR>:Format<CR>

  " easy align
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)

  " autocommands 
  augroup c_language_autocmd
    autocmd! BufEnter *.c set makeprg=make
  augroup END

  augroup fugitive_mapping_autocmd
    function DiffModeMap()
      if &diff
        set cursorline
        nmap gj <cmd>diffget LOCAL<CR>
        nmap gk <cmd>diffget REMOTE<CR>
      endif
    endfunction

    autocmd! BufEnter * call DiffModeMap()
  augroup END

  augroup cursor_hold_hints_autocmd
    autocmd! CursorHold * lua vim.diagnostic.open_float({ scope = "cursor", focus = false })
    autocmd! CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
  augroup END

  augroup chmod_my_script_autocmd
    autocmd! BufWinEnter ~/code/scripts/* if &ft == "" | setlocal ft=sh | endif
    autocmd! BufWritePost * if &ft == "sh" | silent! execute "!chmod +x %" | endif
  augroup END

  augroup FormatAutogroup
    autocmd!
    autocmd User FormatterPre mkview
    autocmd User FormatterPost loadview | silent! edit | silent! norm zO
  augroup END

  " table mode
  function! s:isAtStartOfLine(mapping)
    let text_before_cursor = getline('.')[0 : col('.')-1]
    let mapping_pattern = '\V' . escape(a:mapping, '\')
    let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
    return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
  endfunction

  inoreabbrev <expr> <bar><bar>
            \ <SID>isAtStartOfLine('\|\|') ?
            \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'

  inoreabbrev <expr> __
            \ <SID>isAtStartOfLine('__') ?
            \ '<c-o>:silent! TableModeDisable<cr>' : '__'
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local auto_cmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

-- Config HTML indent style
auto_cmd({ "BufEnter" }, {
  pattern = { "*.json", "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.liquid" },
  callback = function()
    vim.g.html_indent_style1 = "inc"
    vim.g.html_indent_script1 = "inc"
  end,
})

-- Enable formatter
auto_cmd({ "BufEnter" }, {
  pattern = { "*.json", "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.liquid", "*.c", "*.rs" },
  callback = function()
    map("n", "gq", ":Format<CR>", { desc = "Formatter format" })
  end,
})

require("lazy").setup({
  "nvim-treesitter/nvim-treesitter",
  "tpope/vim-fugitive",
  "tpope/vim-liquid",
  "tpope/vim-markdown",
  "pangloss/vim-javascript",
  "junegunn/vim-easy-align",
  "dhruvasagar/vim-table-mode",

  "MaxMEllon/vim-jsx-pretty",
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light"
      vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local previewers = require("telescope.previewers")
      local themes = require("telescope.themes")
      local ivy_theme_config = { sorting_strategy = "ascending", prompt_position = "bottom" }
      local default_opts = themes.get_ivy(ivy_theme_config)

      telescope.setup({
        defaults = vim.tbl_deep_extend("force", default_opts, {
          file_ignore_patterns = {
            ".git/",
            "node_modules",
          },
          preview = {
            hide_on_startup = false,
          },
          mappings = {
            i = {
              ["<cr>"] = actions.select_default + actions.center,
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-h>"] = action_layout.toggle_preview,
            },
          },
          buffer_previewer_maker = function(filepath, bufnr, opts)
            opts = opts or {}
            filepath = vim.fn.expand(filepath)
            vim.loop.fs_stat(filepath, function(_, stat)
              if not stat then return end
              if stat.size > 2e6 then return
              else previewers.buffer_previewer_maker(filepath, bufnr, opts) end
            end)
          end,
        }),
      })

      map("n", "<C-p>", builtin.live_grep, { desc = "Browse files" })
      map("n", "<C-f>", require("api.telescope").my_find_files, { desc = "Browse files" })
      map("n", "<C-g>", require("api.telescope").change_directory, { desc = "Change directory" })
      map("n", "<leader>b", builtin.buffers, { desc = "Recent buffers" })
      map("n", "<leader>?", builtin.oldfiles, { desc = "Recent files" })
      map("n", "<leader>d", builtin.diagnostics, { desc = "List diagnostics" })
      map("n", "<leader>qf", vim.diagnostic.setqflist, { desc = "List diagnostics" })
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      local util = require("formatter.util")
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.info,
        filetype = {
          c = require("formatter.filetypes.c").clangformat,
          json = require("formatter.filetypes.json").prettierd,
          jsonc = require("formatter.filetypes.json").prettierd,
          css = require("formatter.filetypes.css").prettierd,
          html = require("formatter.filetypes.html").prettierd,
          javascript = require("formatter.filetypes.javascript").eslint_d,
          javascriptreact = require("formatter.filetypes.javascriptreact").eslint_d,
          typescript = require("formatter.filetypes.typescript").eslint_d,
          typescriptreact = require("formatter.filetypes.typescriptreact").eslint_d,
          rust = require("formatter.filetypes.rust").rustfmt,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Issafalcon/lsp-overloads.nvim",
    },
    config = function()
      require("neodev").setup()

      -- lsp diagnostics
      vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        severity_sort = false,
        virtual_text = false,

        update_in_insert = true,
        underline = true,
        signs = true,
      })

      -- setup to use with diagnostics
      function SignatureFixed()
        vim.api.nvim_command("set eventignore=CursorHold")
        -- vim.lsp.buf.signature_help()
        vim.cmd(":LspOverloadsSignature")
        vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
      end

      function HoverFixed()
        vim.api.nvim_command("set eventignore=CursorHold")
        vim.lsp.buf.hover()
        vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
      end

      local function on_attach(client, bufnr)
        -- helpers
        local buf_set_option = function(...)
          ---@diagnostic disable-next-line: redundant-parameter
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- disable LSP highlight
        client.server_capabilities.semanticTokensProvider = false

        --- Guard against servers without the signatureHelper capability
        if client.server_capabilities.signatureHelpProvider then
          require('lsp-overloads').setup(client, {
            silent = false,
            display_automatically = false,
            ui = {
              border = "single",
              height = nil,
              width = nil,
              wrap = true,
              wrap_at = nil,
              max_width = nil,
              max_height = nil,
              close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
              focusable = true,
              focus = false,
              offset_x = 0,
              offset_y = 0,
              floating_window_above_cur_line = false,
              silent = true
            },
            keymaps = {
              next_signature = "<C-k>",
              previous_signature = "<C-j>",
              next_parameter = "<C-l>",
              previous_parameter = "<C-h>",
              close_signature = "<C-c>"
            },
          })
        end

        map({ "n", "i" }, "<C-k>", SignatureFixed, { desc = "LSP hover" })
        map("n", "K", HoverFixed, { desc = "LSP hover" })
        map("n", "grn", vim.lsp.buf.rename, { desc = "LSP rename" })
        map("n", "gra", vim.lsp.buf.code_action, { desc = "LSP code actions" })

        map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definitions" })
        map("n", "gT", vim.lsp.buf.type_definition, { desc = "Goto type definitions" })
        map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto implementations" })

        local telescope_builtin = require("telescope.builtin")
        map("n", "gr", telescope_builtin.lsp_references, { desc = "Goto references" })
        map("n", "gS", telescope_builtin.lsp_document_symbols, { desc = "List document symbols" })
        map("n", "gs", telescope_builtin.lsp_workspace_symbols, { desc = "List workspace symbols" })
      end

      local servers_settings = {
        clangd = {
        },
        ts_ls = {
          diagnostics = {
            ignoredCodes = {
              7016,
              80001,
              80002, -- This constructor function may be converted to a class declaration.
            },
          },
          typescript = {
            format = {
              indentSize = 2,
              semicolons = "ignore",
              convertTabsToSpaces = true,
              indentStyle = "Smart",
              trimTrailingWhitespace = true,
            },
          },
          javascript = {
            format = {
              indentSize = 2,
              semicolons = "ignore",
              convertTabsToSpaces = true,
              indentStyle = "Smart",
              trimTrailingWhitespace = true,
            },
          },
        },
        lua_ls = {
          Lua = {
            format = {
              enable = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        emmet_language_server = {
          filetypes = {
            "css",
            "html",
            "liquid",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          init_options = {
            preferences = {},
            showexpandedabbreviation = "always",
            showabbreviationsuggestions = true,
            showsuggestionsassnippets = false,
            syntaxprofiles = {},
            variables = {},
            excludelanguages = {},
          },
        },
      }

      require("mason").setup()
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers_settings)
      })

      -- Swift
      -- require("lspconfig").sourcekit.setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
      },
    },
  },
  {
    "echasnovski/mini.comment",
    config = function()
      require("mini.comment").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")

      luasnip.config.set_config({
        region_check_events = 'InsertEnter',
        delete_check_events = 'InsertLeave'
      })

      require("luasnip.loaders.from_vscode").load({
        include = {
          "all",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "liquid",
          "markdown",
          "c",
          "rust",
        },
      })
      luasnip.filetype_set("javascript", { "javascriptreact" })
      luasnip.filetype_set("typescript", { "typescriptreact" })

      local cmp = require("cmp")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
        },
        ---@diagnostic disable-next-line: missing-fields
        completion = {
          max_item_count = 8,
          keyword_length = 2,
        },
      })
    end,
  },
}, { install = { colorscheme = { "rose-pine" } } })
