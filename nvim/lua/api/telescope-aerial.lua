local api = {}
local backends = require("aerial.backends")
local config = require("aerial.config")
local data = require("aerial.data")

local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")

function api.get_symbols(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(0)
	local backend = backends.get()

	if not backend then
		backends.log_support_err()
		return
	elseif not data:has_symbols(0) then
		backend.fetch_symbols_sync(0, opts)
	end

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 4 },
			{ width = 30 },
			{ remaining = true },
		},
	})

	local function make_display(entry)
		local item = entry.value
		local icon = config.get_icon(bufnr, item.kind)
		local text = vim.api.nvim_buf_get_lines(bufnr, item.lnum - 1, item.lnum, false)[1] or ""
		text = vim.trim(text)
		local columns = {
			{ icon, "Aerial" .. item.kind .. "Icon" },
			{ entry.name, "Aerial" .. item.kind },
			text,
		}
		return displayer(columns)
	end

	local function make_entry(item)
		local name = item.name
		local cur = item.parent

		-- nesting item
		while cur do
			name = string.format("%s.%s", cur.name, name)
			cur = cur.parent
		end

		return {
			value = item,
			display = make_display,
			name = name,
			ordinal = name .. " " .. string.lower(item.kind),
			lnum = item.lnum,
			col = item.col + 1,
			filename = filename,
		}
	end

	local results = {}
	if data:has_symbols(0) then
		data[0]:visit(function(item)
			table.insert(results, item)
		end)
	end

	pickers
		.new(opts, {
			prompt_title = "Document Symbols",
			finder = finders.new_table({
				results = results,
				entry_maker = make_entry,
			}),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

return api
