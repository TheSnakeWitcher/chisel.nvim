local M = {}

M.check_executable = function(executable)
    if not vim.fn.executable(executable) then
        vim.health.report_error(executable .. " missing")
    else
        vim.health.report_ok(executable .. " ok")
    end
end

return M
