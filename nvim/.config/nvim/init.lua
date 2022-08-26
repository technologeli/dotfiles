require('eli.plugins')

vim.g.neoformat_try_node_exe = 1
local has_nvim_tree, nvim_tree = pcall(require, 'nvim-tree')
if has_nvim_tree then
  nvim_tree.setup()
end
