local qf = {}

local open = false

qf.toggle = function ()
  if open then
    open = false
    vim.cmd('cclose')
  else
    open = true
    vim.cmd('copen')
  end
end

return qf
