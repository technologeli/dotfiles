local ag = vim.api.nvim_create_augroup
local ac = vim.api.nvim_create_autocmd

local bo = vim.bo

local fmt = ag('fmt', { clear = true })
ac('BufWritePre', {
  pattern = { '*.tsx', '*.ts' },
  command = 'Neoformat',
  group = fmt
})

local langs = ag('langs', { clear = true })
ac('FileType', {
  pattern = { 'python', 'go', 'cs' },
  callback = function()
    bo.tabstop = 4
    bo.shiftwidth = 4
    bo.softtabstop = 4
    bo.expandtab = true
  end,
  group = langs
})

local has_harpoon, _ = pcall(require, 'harpoon')
if not has_harpoon then
  return
end

local harp = ag('harp', { clear = true })
ac({ 'BufNewFile', 'BufReadPost', 'BufEnter' }, {
  pattern = '*',
  callback = function()
    local m = require('harpoon.mark').status()
    if m == '' then
      return m
    else
      return 'H:' .. m
    end
  end,
  group = harp
})
