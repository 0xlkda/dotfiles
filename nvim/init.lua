-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Options
vim.g.omni_sql_no_default_maps = 1
vim.opt.updatetime = 60
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 2
vim.opt.signcolumn = "yes"
vim.opt.complete:remove({ "t", "i" })
vim.opt.completeopt = "fuzzy,menuone,preview,noselect"
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.whichwrap = "b,s,<,>,h,l,[,]"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.splitright = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 6
vim.opt.foldcolumn = "0"
vim.opt.fillchars = { fold = " " }
vim.o.grepprg = "rg --vimgrep --smart-case"

-- Tmux theme sync server
if vim.env.TMUX then
  local pane_id = vim.fn.system("tmux display-message -p '#{pane_id}'"):gsub("%s+", "")
  local sock = "/tmp/nvim-tmux-" .. pane_id:gsub("%%", "")
  os.remove(sock)
  vim.fn.serverstart(sock)
end

-- Keymaps
local map = vim.keymap.set
local auto_cmd = vim.api.nvim_create_autocmd

-- sync scroll direction with tmux @scroll-reversed setting
function SyncScroll()
  local reversed = vim.fn.system("tmux show -gv @scroll-reversed 2>/dev/null"):gsub("%s+", "") == "1"
  local up = reversed and "1<C-e>" or "1<C-y>"
  local down = reversed and "1<C-y>" or "1<C-e>"
  map("n", "<ScrollWheelUp>", up, { noremap = true })
  map("n", "<ScrollWheelDown>", down, { noremap = true })
  map("i", "<ScrollWheelUp>", "<C-o>" .. up, { noremap = true })
  map("i", "<ScrollWheelDown>", "<C-o>" .. down, { noremap = true })
  map("v", "<ScrollWheelUp>", up, { noremap = true })
  map("v", "<ScrollWheelDown>", down, { noremap = true })
end
SyncScroll()
auto_cmd("FocusGained", { callback = SyncScroll })

-- better zoom
map("n", "<C-w>o", ":mksession! ~/.config/nvim/session.vim<CR>:wincmd o<CR>", { noremap = true })
map("n", "<C-w>u", ":source ~/.config/nvim/session.vim<CR>", { noremap = true })

map("n", "<space>", "za", { noremap = true })
map("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { noremap = true, silent = true })
map("v", "<", "<gv", { noremap = true })
map("v", ">", ">gv", { noremap = true })

-- fold level shortcuts
map("n", "zM", ":set foldlevel=0<CR>", { noremap = true })
map("n", "zm", ":set foldlevel=1<CR>", { noremap = true })
for i = 2, 9 do
  map("n", "z" .. i .. "f", ":set foldlevel=" .. i .. "<CR>", { noremap = true })
end

-- keep cursor in place
map("n", "J", "mzJ`z", { noremap = true })

map("n", "<leader>x", ":silent !chmod +x %<CR>", { noremap = true })

-- moving line
map("n", "<M-j>", ":m .+1<CR>==", { noremap = true })
map("n", "<M-k>", ":m .-2<CR>==", { noremap = true })
map("i", "<M-j>", "<Esc>:m .+1<CR>==gi", { noremap = true })
map("i", "<M-k>", "<Esc>:m .-2<CR>==gi", { noremap = true })
map("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true })

-- diagnostics
map("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true })
map("n", "gl", function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { noremap = true })

-- jumps
map("n", "<C-j>", ":lprev<CR>zz", { noremap = true })
map("n", "<C-k>", ":lnext<CR>zz", { noremap = true })

-- split lines
vim.api.nvim_create_user_command("Split", "'<,'>s/, /,\\r/gI", { range = true })
map("v", "<leader>s", ":Split<CR>:nohl<CR>:Format<CR>")

-- easy align
map("x", "ga", "<Plug>(EasyAlign)")
map("n", "ga", "<Plug>(EasyAlign)")

-- Autocmds
local function close_floating_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
    if ok and cfg and cfg.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end

-- highlight current line
auto_cmd("ModeChanged", {
  pattern = "*:*",
  callback = function()
    local transition = vim.v.event.old_mode .. ":" .. vim.v.event.new_mode
    local mappings = {
      ["i:n"] = function() vim.opt.cursorline = false end,
      ["n:i"] = function() vim.opt.cursorline = true end,
    }
    if mappings[transition] and vim.bo.ft ~= "TelescopePrompt" then
      mappings[transition]()
    end
  end,
})

-- config HTML indent style
auto_cmd("BufEnter", {
  pattern = { "*.json", "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.liquid" },
  callback = function()
    vim.g.html_indent_style1 = "inc"
    vim.g.html_indent_script1 = "inc"
  end,
})

-- enable formatter
auto_cmd("BufEnter", {
  pattern = { "*.lua", "*.json", "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.liquid", "*.c", "*.rs", "*.py" },
  callback = function()
    map("n", "gq", ":Format<CR>", { desc = "Formatter format" })
  end,
})

-- REST response
local vrc_group = vim.api.nvim_create_augroup("vrc_response", { clear = true })
auto_cmd("BufEnter", {
  group = vrc_group,
  pattern = "__REST_response__",
  callback = function()
    vim.bo.modifiable = true
    map("n", "gq", ":normal! V<CR>:!jq<CR>", { buffer = true })
  end,
})

-- c language
local c_group = vim.api.nvim_create_augroup("c_language_autocmd", { clear = true })
auto_cmd("BufEnter", {
  group = c_group,
  pattern = "*.c",
  callback = function() vim.opt_local.makeprg = "make" end,
})

-- diff mode mappings
local function diff_mode_map()
  if vim.wo.diff then
    vim.opt.cursorline = true
    map("n", "gj", "<cmd>diffget //2<CR>", { buffer = true })
    map("n", "gk", "<cmd>diffget //3<CR>", { buffer = true })
  end
end
local fugitive_group = vim.api.nvim_create_augroup("fugitive_mapping_autocmd", { clear = true })
auto_cmd("BufEnter", {
  group = fugitive_group,
  pattern = "*",
  callback = diff_mode_map,
})

-- cursor hold hints
local cursor_hold_group = vim.api.nvim_create_augroup("cursor_hold_hints_autocmd", { clear = true })
auto_cmd("CursorHold", {
  group = cursor_hold_group,
  callback = function()
    vim.diagnostic.open_float({ scope = "cursor", focus = false })
  end,
})
auto_cmd({ "CursorMoved", "CursorMovedI" }, {
  group = cursor_hold_group,
  callback = function() vim.lsp.buf.clear_references() end,
})

-- chmod scripts
local chmod_group = vim.api.nvim_create_augroup("chmod_my_script_autocmd", { clear = true })
auto_cmd("BufWinEnter", {
  group = chmod_group,
  pattern = vim.fn.expand("~/code/scripts/*"),
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "sh"
    end
  end,
})
auto_cmd("BufWritePost", {
  group = chmod_group,
  callback = function()
    if vim.bo.filetype == "sh" then
      vim.fn.system("chmod +x " .. vim.fn.expand("%"))
    end
  end,
})

-- formatter view save/restore
local format_group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
auto_cmd("User", {
  group = format_group,
  pattern = "FormatterPre",
  command = "mkview",
})
auto_cmd("User", {
  group = format_group,
  pattern = "FormatterPost",
  command = "loadview | silent! norm zO",
})

-- disable folding in telescope results
auto_cmd("FileType", {
  pattern = "TelescopeResults",
  callback = function() vim.opt_local.foldenable = false end,
})

-- delete item in quickfix
local function remove_qf_item()
  local idx = vim.fn.line(".") - 1
  local qfall = vim.fn.getqflist()
  table.remove(qfall, idx + 1)
  vim.fn.setqflist(qfall, "r")
  vim.cmd((idx + 1) .. "cfirst")
  vim.cmd("copen")
end
auto_cmd("FileType", {
  pattern = "qf",
  callback = function()
    map("n", "dd", remove_qf_item, { buffer = true })
  end,
})

-- table mode (kept as vim.cmd — relies on <SID> and script-local functions)
vim.cmd([[
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

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.ts",
  callback = function()
    if vim.bo.filetype ~= "typescript" then
      vim.bo.filetype = "typescript"
    end
  end,
})

-- LSP
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
      2589,
      7016,
      80001,
      80002,
    },
  },
}

vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}

vim.lsp.enable({ "ts_ls", "pyright" })

auto_cmd("LspAttach", {
  callback = function(ev)
    local buffer = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    map("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "Goto definitions" })
    map("n", "gT", vim.lsp.buf.type_definition, { buffer = buffer, desc = "Goto type definitions" })

    local function setup_signature_helps()
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
        },
      })
    end

    if client.server_capabilities.signatureHelpProvider then
      setup_signature_helps()

      local function SignatureFixed()
        close_floating_windows()
        vim.opt.eventignore:append({ "CursorHold", "CursorHoldI" })
        vim.cmd(":silent LspOverloadsSignature")
        vim.api.nvim_command('autocmd CursorMoved,CursorMovedI <buffer> ++once set eventignore=""')
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

      local function HoverFixed()
        close_floating_windows()
        vim.opt.eventignore:append({ "CursorHold" })
        vim.lsp.buf.hover()
        vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
      end

      map("n", "K", HoverFixed, { buffer = buffer, desc = "LSP hover" })
    end
  end,
})

-- Plugins
require("lazy").setup({
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end
  },
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

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      vim.api.nvim_create_user_command("DapCloseUI", function()
        dapui.close()
      end, {})

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
      local overlays = { light = "#eee8e1", dark = "#393552" }

      function SyncTheme()
        local theme = vim.fn.system("tmux show -gv @theme 2>/dev/null"):gsub("%s+", "")
        if theme ~= "light" and theme ~= "dark" then
          theme = "dark"
        end
        vim.o.background = theme
        vim.cmd("colorscheme rose-pine")
        vim.api.nvim_set_hl(0, "NormalNC", { bg = overlays[theme] })
      end

      SyncTheme()

      vim.api.nvim_create_autocmd("FocusGained", { callback = SyncTheme })
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
            vim.uv.fs_stat(filepath, function(_, stat)
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
