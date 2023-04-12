if vim.fn.has("nvim-0.8.0") == 0 then
  vim.notify("chisel requires at least nvim-0.8.0.1")
  return
end

if vim.g.loaded_chisel == true then
  return
end
vim.g.loaded_chisel = true
