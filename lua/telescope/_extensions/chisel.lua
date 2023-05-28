local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	vim.notify("chisel.nvim requires nvim-telescope/telescope.nvim")
    return
end


local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local chisel = require("chisel")


local chisel_sessions_finder = finders.new_table({
    results = chisel.list(),
    entry_maker = function(entry)
        return {
            value = entry,
            display = entry.id,
            ordinal = entry.id,
        }
    end
})

local chisel_sessions_mappings = function(prompt_bufnr, map)
    actions.select_default:replace(function()
	    actions.close(prompt_bufnr)
	    local selection = actions_state.get_selected_entry()
        chisel.load(selection.value.id)
    end)
    return true
end

local chisel_sessions_previewer = previewers.new_termopen_previewer({
    get_command = function(entry,status)
        return { "chisel" , "view" , entry.value.id }
    end,
})


local chisel_sessions_picker = function(opts)
	opts = opts or {}
	pickers.new(opts, {
		prompt_title = "chisel sessions",
        finder = chisel_sessions_finder,
		sorter = conf.generic_sorter(opts),
		attach_mappings = chisel_sessions_mappings,
		previewer = chisel_sessions_previewer,
	})
	:find()
end

return telescope.register_extension({
	exports = {
		chisel = chisel_sessions_picker,
	},
})
