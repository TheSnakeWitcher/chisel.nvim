local M = {}

M.namespace = vim.api.nvim_create_namespace("chisel.nvim")

M.default_config = {
    direction = "float",
}

function M.setup(user_config)
    return vim.tbl_deep_extend("force",M.default_config,user_config or {})
end

return M
