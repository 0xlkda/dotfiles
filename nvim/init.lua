-- packages management
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
-- end packages management

function close_floating_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
    if ok and cfg and cfg.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end

local auto_cmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

-- Highlight current line
auto_cmd("ModeChanged", {
  pattern = "*:*",
  callback = function()
    local transition = vim.v.event.old_mode .. ":" .. vim.v.event.new_mode
    local mappings = {
      ["i:n"] = function()
        vim.cmd("set nocul")
      end,
      ["n:i"] = function()
        vim.cmd("set cul")
      end,
    }

    if mappings[transition] and vim.bo.ft ~= "TelescopePrompt" then
      mappings[transition]()
    end
  end,
})

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
  pattern = {
    "*.lua",
    "*.json",
    "*.js",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.html",
    "*.css",
    "*.liquid",
    "*.c",
    "*.rs",
    "*.py",
  },
  callback = function()
    map("n", "gq", ":Format<CR>", { desc = "Formatter format" })
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
  set completeopt=fuzzy,menuone,preview,noselect
  set incsearch
  set ignorecase
  set smartcase
  set whichwrap="b,s,<,>,h,l,[,],`"
  set grepprg="rg --vimgrep --smart-case"
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  set wrap
  set linebreak
  set splitright

  let g:mapleader = ","
  let g:maplocalleader = ","

  " better zoom
  nnoremap <C-w>o :mksession! ~/.config/nvim/session.vim<CR>:wincmd o<CR>
  nnoremap <C-w>u :source ~/.config/nvim/session.vim<CR>

  nnoremap <space> za
  nnoremap <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>
  vnoremap < <gv
  vnoremap > >gv

  " folding
  set foldlevel=99
  set foldlevelstart=1
  set foldnestmax=6
  set foldcolumn=0
  set fillchars=fold:\ 

  nnoremap zM :set foldlevel=0<CR>
  nnoremap zm :set foldlevel=1<CR>
  nnoremap z2f :set foldlevel=2<CR>
  nnoremap z3f :set foldlevel=3<CR>
  nnoremap z4f :set foldlevel=4<CR>
  nnoremap z5f :set foldlevel=5<CR>
  nnoremap z6f :set foldlevel=6<CR>
  nnoremap z7f :set foldlevel=7<CR>
  nnoremap z8f :set foldlevel=8<CR>
  nnoremap z9f :set foldlevel=9<CR>

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

  " jumps
  nnoremap <C-j> :lprev<CR>zz
  nnoremap <C-k> :lnext<CR>zz

  " split lines
  command! -range Split '<,'>s/, /,\r/gI
  vmap <leader>s :Split<CR>:nohl<CR>:Format<CR>

  " easy align
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)

  " autocommands 
  augroup vrc_response
  autocmd! BufEnter __REST_response__ 
  \ set modifiable |
  \ nnoremap <buffer> gq :normal! V<CR>:!jq<CR>
  augroup END

  augroup c_language_autocmd
  autocmd! BufEnter *.c set makeprg=make
  augroup END

  augroup fugitive_mapping_autocmd
    function DiffModeMap()
      if &diff
        set cursorline
        nmap gj <cmd>diffget //2<CR>
        nmap gk <cmd>diffget //3<CR>
      endif
    endfunction

    autocmd! BufEnter * call DiffModeMap()
  augroup END

  augroup cursor_hold_hints_autocmd
  autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float({ scope = "cursor", focus = false })
  autocmd CursorMoved, CursorMovedI * lua vim.lsp.buf.clear_references()
  augroup END

  augroup chmod_my_script_autocmd
  autocmd!
  autocmd BufWinEnter ~/code/scripts/* if &ft == "" | setlocal ft=sh | endif
  autocmd BufWritePost * if &ft == "sh" | silent! execute "!chmod +x %" | endif
  augroup END

  augroup FormatAutogroup
  autocmd!
  autocmd User FormatterPre mkview
  autocmd User FormatterPost loadview | silent! norm zO
  augroup END

  " table mode
  function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
  endfunction

  " disable folding in telescope's result window
  autocmd! FileType TelescopeResults setlocal nofoldenable

  inoreabbrev <expr> <bar><bar>
  \ <SID>isAtStartOfLine('\|\|') ?
  \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'

  inoreabbrev <expr> __
  \ <SID>isAtStartOfLine('__') ?
  \ '<c-o>:silent! TableModeDisable<cr>' : '__'

  " Delete item in quickfix
  function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
  endfunction
  autocmd FileType qf map <buffer> dd :call RemoveQFItem()<cr>
]])

-- setup lsp
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", ".git" },
  single_file_support = false,
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "non-relative",
    },
  },
  diagnostics = {
    ignoredCodes = {
      2589, -- Type instantiation is excessively deep and possibly infinite. [2589]
      7016,
      80001,
      80002, -- This constructor function may be converted to a class declaration.
    },
  },
}

--python
vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = {
    "python",
  },
  root_markers = { 
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  }
}

vim.lsp.enable({ "ts_ls", "pyright" })

auto_cmd("LspAttach", {
  callback = function(ev)
    local buffer = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local buf_set_option = function(...)
      vim.api.nvim_buf_set_option(buffer, ...)
    end

    -- lsp mappings
    map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definitions" })
    map("n", "gT", vim.lsp.buf.type_definition, { desc = "Goto type definitions" })

    -- signature helps
    function setup_signature_helps()
      require("lsp-overloads").setup(client, {
        ui = {
          border = "single",
          height = nil,
          width = nil,
          wrap = true,
          wrap_at = 80,
          max_width = nil,
          max_height = nil,
          close_events = { "CursorMovedI", "CursorMoved", "BufHidden", "InsertLeave" },
          focusable = true,
          focus = false,
          offset_x = 0,
          offset_y = 0,
          floating_window_above_cur_line = true,
          silent = true,
        },
        keymaps = {
          next_signature = "<C-k>",
          previous_signature = "<C-j>",
          next_parameter = "<C-l>",
          previous_parameter = "<C-h>",
          -- close_signature = "<C-c>"
        },
      })
    end

    if client.server_capabilities.signatureHelpProvider then
      setup_signature_helps()

      function SignatureFixed()
        close_floating_windows()
        vim.opt.eventignore:append({ "CursorHold", "CursorHoldI" })
        vim.cmd(":silent LspOverloadsSignature") -- vim.lsp.buf.signature_help()
        vim.api.nvim_command('autocmd CursorMoved, CursorMovedI <buffer> ++once set eventignore=""')
      end

      auto_cmd("CursorHoldI", {
        pattern = { "*.ts", "*.tsx", "*.js" },
        callback = SignatureFixed,
      })

      map(
        { "n", "i" },
        "<C-s>",
        SignatureFixed,
        { buffer = buffer, desc = "LspOverloadsSignature" }
      )

      function HoverFixed()
        close_floating_windows()
        vim.opt.eventignore:append({ "CursorHold" })
        vim.lsp.buf.hover()
        vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
      end

      map({ "n" }, "K", HoverFixed, { buffer = buffer, desc = "LSP hover" })
    end
  end,
})

require("lazy").setup({
  "dhruvasagar/vim-table-mode",
  "diepm/vim-rest-console",
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dapui = require("dapui")
      local dap = require("dap")

      dap.adapters.node2 = {
        type = "executable",
        command = "node-debug2-adapter",
        args = {},
      }

      dap.configurations.typescript = {
        {
          type = "node2",
          request = "attach",
          name = "Attach",
          cwd = vim.fn.getcwd(),
        },
      }

      dapui.setup()

      -- open Dap UI automatically when debug starts (e.g. after <F5>)
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      -- close Dap UI with :DapCloseUI
      vim.api.nvim_create_user_command("DapCloseUI", function()
        dapui.close()
      end, {})

      -- use <Alt-e> to eval expressions
      map({ "n", "v" }, "<leader>e", require("dapui").eval)
      map("n", "<leader>dn", ":DapNew<CR>")
      map("n", "<leader>v", ":DapViewToggle<CR>")
      map("n", "<F9>", require("dap").toggle_breakpoint)
      map("n", "<leader>b", require("dap").toggle_breakpoint)
      map("n", "<F5>", require("dap").continue)
      map("n", "<F10>", require("dap").step_over)
      map("n", "<F11>", require("dap").step_into)
      map("n", "<F12>", require("dap").step_out)
      map("n", "<leader>B", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end)
      map("n", "<Leader>lp", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end)
      map("n", "<Leader>dr", function()
        require("dap").repl.open()
      end)
      map("n", "<Leader>dl", function()
        require("dap").run_last()
      end)
    end,
  },
  "tpope/vim-fugitive",
  "tpope/vim-liquid",
  "tpope/vim-markdown",
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "pgsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = "~/code/db"
      vim.g.db_ui_tmp_query_location = "~/code/db/.query"
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "sql",
        callback = function()
          map({ "n", "v" }, "<CR>", "<Plug>(DBUI_ExecuteQuery)<CR>", { buffer = true })
        end,
      })
    end,
  },
  "pangloss/vim-javascript",
  "junegunn/vim-easy-align",
  "MaxMEllon/vim-jsx-pretty",
  "Issafalcon/lsp-overloads.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
    },
    config = function()
      local read_query = function(filename)
        return table.concat(vim.fn.readfile(vim.fn.expand(filename)))
      end

      require("nvim-treesitter.configs").setup({
        modules = {},
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        ensure_installed = {
          "c",
          "vim",
          "vimdoc",
          "markdown",
          "lua",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
        },
        highlight = {
          enable = true,
        },
      })

      local typescript_folds = read_query("~/.config/nvim/after/queries/typescript/folds.scm")
      vim.treesitter.query.set("typescript", "folds", typescript_folds)
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        get_opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },
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
              if not stat then
                return
              end
              if stat.size > 2e6 then
                return
              else
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
              end
            end)
          end,
        }),
      })

      map("n", "<C-p>", builtin.live_grep, { desc = "Browse files" })
      map("n", "<C-f>", require("api.telescope").my_find_files, { desc = "Browse files" })
      map("n", "<C-g>", require("api.telescope").change_directory, { desc = "Change directory" })
      -- map("n", "<leader>b", builtin.buffers, { desc = "Recent buffers" })
      map("n", "<leader>?", builtin.oldfiles, { desc = "Recent files" })
      map("n", "<leader>d", builtin.diagnostics, { desc = "List diagnostics" })
      map("n", "<leader>qf", vim.diagnostic.setqflist, { desc = "List diagnostics" })
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      local util = require("formatter.util")
      local function eslint_d()
        -- vim.env.ESLINT_USE_FLAT_CONFIG = true

        return {
          exe = "eslint_d",
          args = {
            "--config",
            "~/code/dotfiles/eslint_d/eslint.config.mjs",
            "--stdin",
            "--stdin-filename",
            util.escape_path(util.get_current_buffer_file_path()),
            "--fix-to-stdout",
          },
          stdin = true,
          try_node_modules = true,
        }
      end

      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.DEBUG,
        filetype = {
          c = require("formatter.filetypes.c").clangformat,
          json = require("formatter.filetypes.json").prettier,
          jsonc = require("formatter.filetypes.json").prettier,
          css = require("formatter.filetypes.css").prettier,
          html = require("formatter.filetypes.html").prettier,
          javascript = eslint_d,
          javascriptreact = eslint_d,
          typescript = require("formatter.filetypes.typescript").eslint_d,
          typescriptreact = require("formatter.filetypes.typescriptreact").eslint_d,
          rust = require("formatter.filetypes.rust").rustfmt,
          python = require("formatter.filetypes.python").black,
          lua = require("formatter.filetypes.lua").stylua,
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        -- See `:help gitsigns.txt`
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
        },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("Comment").setup({
        toggler = {
          line = "gcc",
          block = "gcb",
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
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
        region_check_events = "InsertEnter",
        delete_check_events = "InsertLeave",
      })

      luasnip.filetype_set("typescript", { "javascript" })

      require("luasnip.loaders.from_vscode").load({
        include = {
          "all",
          "jest",
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

      local cmp = require("cmp")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
            == nil
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
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({ select = true })
              end
            else
              fallback()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
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
          keyword_length = 1,
        },
      })
    end,
  },
}, { install = { colorscheme = { "rose-pine" } } })
