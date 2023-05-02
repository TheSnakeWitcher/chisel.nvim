local Terminal = require("toggleterm.terminal").Terminal
local Job = require("plenary.job")

local chisel = {}

local defaults = {
    direction = "float",
}


function chisel.setup(options)

    chisel.options = vim.tbl_deep_extend("force",options or {},defaults)

    vim.api.nvim_create_user_command("Chisel", chisel.open , {})
    vim.api.nvim_create_user_command("ChiselLoad", chisel.load , {})
    vim.api.nvim_create_user_command("ChiselClearCache", chisel.clear_cache , {})

end


function chisel.open()
    Terminal:new({
        cmd = "chisel" ,
        direction = chisel.options.direction,
        close_on_exit = true,
    }):toggle()
end


-- displays all cached sessions stored in ~/.foundry/cache/chisel.
function chisel.list()
    -- execute chisel list
    -- telescope picker (maybe with easy picker)
    -- telescope previewer chisel.view
    -- telescope action chisel.load
end


-- if a cached session with id = <id> exists, launches the REPL and loads the corresponding session.
function chisel.load()
    vim.ui.input({prompt = "session id: "},function(id) 
        Terminal:new({
            cmd = "chisel" ,
            arg = {"load",id},
            direction = chisel.options.direction,
            close_on_exit = false,
        }):toggle()
    end)
end


-- if a cached session with id = <id> exists, displays the source code of the session's REPL contract.
function chisel.view(id)
    Terminal:new({
        cmd = "chisel" ,
        arg = {"view",id},
        direction = chisel.options.direction,
        close_on_exit = true,
    }):toggle()
end


-- deletes all cache files within the ~/.foundry/cache/chisel directory. These sessions are unrecoverable, so use this command with care.
function chisel.clear_cache()
    Job:new({
        command = "chisel" ,
        args = {"clear-cache"},
        on_exit = vim.notify("chisel cached cleaned")
    }):spawn()
end


return chisel
