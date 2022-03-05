-- Telescope
local themes = require("telescope.themes")
local previewers = require("telescope.previewers")
local previewSmallFileOnly = function(filepath, bufnr, opts)
	opts = opts or {}

	filepath = vim.fn.expand(filepath)
	vim.loop.fs_stat(filepath, function(_, stat)
		if not stat then return end
		if stat.size > 1000000 then
			return
		else
			previewers.buffer_previewer_maker(filepath, bufnr, opts)
		end
	end)
end

require "telescope".setup {
	defaults = {
		buffer_previewer_maker = previewSmallFileOnly,
		layout_strategy = "vertical",
		layout_config = {
			vertical = { preview_cutoff = 30 }
		}
	},

	extensions = {
		extensions = {
			fzy_native = {
				override_generic_sorter = false,
				override_file_sorter = true,
			}
		},

		tmuxinator = {
			select_action = "switch", -- | "stop" | "kill"
			stop_action = "stop", -- | "kill"
			disable_icons = false,
		},
	}

}

require "telescope".load_extension("fzy_native")
require "telescope".load_extension("buffer_lines")
require "telescope".load_extension("tmuxinator")

Telescope_project_files = function()
	local opts = require('telescope.themes').get_ivy { shorten_path = true	}
	local ok = pcall(require "telescope.builtin".git_files, opts)
	if not ok then require "telescope.builtin".find_files(opts) end
end

vim.api.nvim_set_keymap("n","<C-\\>",
	"<CMD>lua require 'telescope'.extensions.tmuxinator.projects(require 'telescope.themes'.get_dropdown())<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap("n", "<C-p>",
	"<CMD>lua Telescope_project_files()<CR>",
	{ noremap = true, silent = true }
)
