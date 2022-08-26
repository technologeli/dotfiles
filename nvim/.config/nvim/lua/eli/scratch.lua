local endswith = require('eli.utils').endswith

local s = {}

local n = 'scratch'

s.scratch = function ()
  -- if current buffer is scratch do nothing
  if endswith(vim.api.nvim_buf_get_name(0), n) then
    return
  end

  -- check if scratch exists
  local bufs = vim.api.nvim_list_bufs()

  for _, b in ipairs(bufs) do
    -- if scratch exists switch to it
    if endswith(vim.api.nvim_buf_get_name(b), n) then
      vim.api.nvim_win_set_buf(0, b)
      return
    end
  end

  -- scratch does not exist, create and switch to it
  local b = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(b, n)
  vim.api.nvim_buf_set_option(b, 'buftype', 'nofile')
  vim.api.nvim_win_set_buf(0, b)
end

return s
