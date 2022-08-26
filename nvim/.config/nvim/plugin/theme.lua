vim.cmd[[
  if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
]]

local has_colorbuddy, colorbuddy = pcall(require, 'colorbuddy')
if has_colorbuddy then
  colorbuddy.colorscheme('gruvbox')
  local Color, colors, Group, _, styles = require('colorbuddy').setup()

  -- _ to not override
  Color.new('_cyan', '#458588')
  Color.new('_purple', '#b16286')
  Color.new('_yellow', '#d79921')
  Color.new('_soft', '#3c3836')

  -- fg, bg, style
  Group.new('Normal', nil, nil, nil)

  Group.new('Pmenu', nil, nil, nil)
  Group.new('PmenuThumb', nil, colors._cyan, nil)
  Group.new('QuickFixLine', colors._purple, nil, nil)

  Group.new('TelescopeSelectionCaret', colors._cyan, nil, nil)
  Group.new('TelescopeSelection', colors._yellow, nil, styles.bold)
  Group.new('TelescopeBorder', colors._purple, nil, nil)
  Group.new('TelescopeMatching', colors._yellow, nil, nil)
  Group.new('TelescopePromptPrefix', colors._cyan, nil, nil)

  Group.new('TreeSitterContext', nil, colors._soft, nil, nil)
end


local has_colorizer, colorizer = pcall(require, 'colorizer')
if has_colorizer then
  colorizer.setup({ '*' }, {
    RRGGBBAA = true;
    rgb_fn   = true;
    hsl_fn   = true;
    mode = 'background';
  })
end
