local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  return
end

local actions = require'telescope.actions'
telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
      },
    mappings = {
      i = {
      },
      n = {
        ["q"] = actions.close,
        ["l"] = actions.select_default + actions.center
      }
    }
  }
}
