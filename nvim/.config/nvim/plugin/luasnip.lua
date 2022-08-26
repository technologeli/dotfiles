local has_luasnip, ls = pcall(require, 'luasnip')
if not has_luasnip then
  return
end

local types = require 'luasnip.util.types'

ls.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
}

vim.keymap.set({ 'i', 's' }, '<c-j>', function ()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<c-k>', function ()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set('i', '<c-l>', function ()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- 0 is the last for some reason
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
-- local rep = require('luasnip.extras').rep

local same = function (index)
  return f(function (arg)
    return arg[1]
  end, { index })
end

-- use c-l to switch between choices

-- All
ls.add_snippets('all', {
  s('task', { c(1, {t "TODO", t "DONE"}) } ),
  s('curtime', f(function () return os.date "%D - %I:%M %p" end))
})

-- Lua
ls.add_snippets('lua', {
  s('req', fmt("local {} = require('{}')", {
    f(function(import_name)
      local parts = vim.split(import_name[1][1], '.', true)
      return parts[#parts] or ""
    end, { 1 }),
    i(1),
  })),
  -- doesn't get more meta than this
  s('snip', fmt("s('{}', fmt('{}', {{{}}})),", {
    i(1), i(2), i(0),
  })),
  s('preq', fmt([[
  local has_{}, {} = pcall(require, '{}')
  if {}has_{} then
    {}
  end
  ]], {
    i(1),
    same(1),
    same(1),
    c(2, { t '', t 'not ' }),
    same(1),
    i(0)
  })),
})

-- Typescript React
ls.add_snippets('typescriptreact', {
  s('imp', fmt("import {{ {} }} from '{}';", {
    i(1), i(0)
  })),
  s('us', fmt('const [{}, set{}] = useState({});', {
    i(1, 'value'),
    f(function (tab)
      local var_name = tab[1][1]
      local first_letter = string.upper(string.sub(var_name, 1, 1))
      local rest = string.sub(var_name, 2, -1)
      return first_letter .. rest
    end, { 1 }),
    i(0)
  })),
  -- paired tag
  s('pt', fmt('<{}>{}</{}>', {
    i(1),
    i(0),
    f(function (import_name)
      local parts = vim.split(import_name[1][1], ' ', true)
      return parts[1] or ''
    end, { 1 }),
  })),
  -- single tag
  s('st', fmt('<{} />', { i(1) })),
  s('comp', fmt('const {} = ({}) => {{\n}};\n\nexport default {};', {
    i(1),
    i(2),
    same(1)
  })),
})

-- Go
ls.add_snippets('go', {
  s('iferr', fmt(
  [[
  if {} != nil {{
    return {}
  }}
  ]],
  {
    i(1, 'err'),
    i(0)
  }))
})
