local has_which_key, which_key = pcall(require, 'which-key')
if has_which_key then
  which_key.setup {}
end
