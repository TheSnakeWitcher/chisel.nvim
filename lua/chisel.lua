local Terminal = require("toggleterm.terminal").Terminal

local chisel = {}

local defaults = {
    direction = "float",
}

function chisel.setup(options)

    chisel.options = vim.tbl_deep_extend("force",options or {},defaults)

    vim.api.nvim_create_user_command("Chisel", chisel.open , {})

end

function chisel.open()
    Terminal:new({
        cmd = "chisel" ,
        direction = chisel.options.direction,
        close_on_exit = true,
    }):toggle()
end

return chisel
