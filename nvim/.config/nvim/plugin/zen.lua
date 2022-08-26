local has_zen_mode, zen_mode = pcall(require, 'zen-mode')
if has_zen_mode then
  zen_mode.setup {
    window = {
      width = 0.6,
      height = 0.8
    }
  }
end
