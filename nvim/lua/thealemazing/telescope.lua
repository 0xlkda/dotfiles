local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        color_devicons = true,
        set_env = { ['COLORTERM'] = 'truecolor' },

        file_sorter = require('telescope.sorters').get_fzy_sorter,
        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        layout_config = {
            preview_width = 80
        },

        mappings = {
            i = {
                ['<ESC>']   = actions.close,
                ['<C-x>'] = false,
                ['<C-q>'] = actions.send_to_qflist,
            },
        },
    },

    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native') local M = {} M.project_files = function()
    local opts = {}
    local ok = pcall(require('telescope.builtin').git_files, opts)
    if not ok then require('telescope.builtin').find_files(opts) end
end

M.dotfiles = function()
    require('telescope.builtin').find_files({
            prompt_title = '< Dotfiles >',
            cwd = '$HOME/projects/dotfiles/',
        })
end

M.notes = function()
    require('telescope.builtin').file_browser({
            prompt_title = '< Notes >',
            cwd = '$HOME/projects/notes/',
        })
end

return M
