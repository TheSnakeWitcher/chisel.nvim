local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	vim.notify("chisel.nvim requires nvim-telescope/telescope.nvim")
end


local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local chisel = require("chisel")


local chisel_mappings = function(prompt_bufnr, map)
    actions.select_default:replace(function()
	    actions.close(prompt_bufnr)
	    local selection = action_state.get_selected_entry()
        chisel.load(selection.value.id)
    end)
    return true
end

local chisel_finder = finders.new_table({
    results = chisel.list(),
    entry_maker = function(entry)
        return {
            value = entry,
            display = entry.id,
            ordinal = entry.date,
        }
    end
})

local chisel_picker = function(opts)
	opts = opts or {}
	pickers.new(opts, {
		prompt_title = "chisel sessions",
        finder = chisel_finder,
		sorter = conf.generic_sorter(opts),
		attach_mappings = chisel_mappings,
	})
	:find()
end


return telescope.register_extension({
	exports = {
		chisel_sessions = chisel_picker,
	},
})
