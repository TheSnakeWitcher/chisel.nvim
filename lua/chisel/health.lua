local util = require("chisel.util")

local M = {}

M.check = function()
    vim.health.report_start("chisel.nvim report")
    util.check_executable("chisel")
end

return M
