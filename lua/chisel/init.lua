local Terminal = require("toggleterm.terminal").Terminal
local Job = require("plenary.job")
local config = require("chisel.config")

local M = {}
M.config = {}

function M.setup(user_config)

    M.config = config.setup(user_config)

    vim.api.nvim_create_user_command("Chisel", function(opts)
        local args = opts.fargs
        if #args== 0 then
            M.open()
        else
            M.load(args[1])
        end
    end, {
        desc = "launch chisel REPL,in case an argument was passed loads the cached session with {id} if exists",
        nargs = "?",
        -- custom = "customlist",M.list()
    })
    vim.api.nvim_create_user_command("ChiselClearCache", M.clear_cache , {desc = "deletes all cache sessions"})

end

-- launch chisel REPL
function M.open()
    Terminal:new({
        cmd = "chisel" ,
        direction = M.config.direction,
        close_on_exit = true,
    }):toggle()
end


-- list cached sessions stored in ~/.foundry/cache/chisel
function M.list()
    local results = {}

    Job:new({
        command = "chisel" ,
        args = {"list"},
        on_exit = function(job,exitcode)
            local sessions = {}
            local dates = {}

            for _,output in ipairs(job:result()) do
                local data = vim.split(output,"- ")
                local date = data[1]
                local session = data[2]

                table.insert(dates,date)
                table.insert(sessions,session)
            end

            for idx,session in ipairs(sessions) do
                local text , extension =  "chisel" , ".json"
                local extension_starts,_ = string.find(session,extension)
                local _,text_ends = string.find(session,text)
                local id = string.sub(session,text_ends+2,extension_starts-1)

                table.insert(results,{
                    date = dates[idx],
                    id=id
                })
            end

        end
    }):sync()

    return results
end


-- launches the REPL and loads the cached session with {id} in case it exists
function M.load(id)
    Terminal:new({
        cmd = "chisel load " .. id ,
        direction = M.config.direction,
        close_on_exit = false,
    }):toggle()
end


-- displays the source code of the sessions's REPL contract with {id} in case it exists
function M.view(id)
    Terminal:new({
        cmd = "chisel view " .. id ,
        direction = M.config.direction,
        close_on_exit = true,
    }):toggle()
end


-- deletes all cache sessions within ~/.foundry/cache/chisel directory.
-- NOTE: These sessions are unrecoverable, so use this command with care.
function M.clear_cache()
    Job:new({
        command = "chisel" ,
        args = {"clear-cache"},
        on_exit = vim.notify("chisel cached cleaned")
    }):start()
end

return M
