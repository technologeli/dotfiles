local setKey = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

setKey("", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '

local l = function (k)
  return '<leader>' .. k
end

local c = function (com)
  return '<cmd>' .. com .. '<cr>'
end


-- Some commands look like this:
-- nnoremap <leader>{} <cmd>{}<cr>
-- So we can just make a table with those values
-- This also helps with duplicate catching
local tab = {
  -- Nvim Tree
  ['t'] = 'NvimTreeFindFileToggle',
  ['TR'] = 'NvimTreeRefresh',

  -- Telescope
  ['f'] = 'Telescope find_files hidden=true',
  ['.'] = 'Telescope find_files hidden=true search_dirs={"~/dotfiles"}',
  ['lr'] = 'Telescope lsp_references hidden=true',
  ['hd'] = 'Telescope help_tags',

  -- Fugitive
  ['g'] = 'Git',
  -- ['gc'] = 'GBranches',
  -- ['gf'] = 'diffget //2',
  -- ['gj'] = 'diffget //3',

  -- Zen Mode
  ['z'] = 'ZenMode',

}

for k, v in pairs(tab) do
  setKey('n', l(k), c(v), opts)
end

-----------------
-- Other Stuff --
-----------------

-- Navigation
setKey('n', '<M-h>', '<C-w>h', opts)
setKey('n', '<M-j>', '<C-w>j', opts)
setKey('n', '<M-k>', '<C-w>k', opts)
setKey('n', '<M-l>', '<C-w>l', opts)

-- Resize
setKey('n', '<C-M-j>', c('resize -2'), opts)
setKey('n', '<C-M-k>', c('resize +2'), opts)
setKey('n', '<C-M-h>', c('vertical resize +2'), opts)
setKey('n', '<C-M-l>', c('vertical resize -2'), opts)

-- Stay highlighted
setKey('v', '<', '<gv', opts)
setKey('v', '>', '>gv', opts)

-- Navigate buffers
setKey('n', '<S-h>', c('bprev'), opts)
setKey('n', '<S-l>', c('bnext'), opts)

-- Telescope special
setKey('n', '<C-p>', c('Telescope git_files'), opts)
setKey('n', '<C-b>', c('Telescope buffers'), opts)
setKey('n', l('rg'), '', {
  noremap = true,
  callback = function ()
    local has_telescope, _ = pcall(require, 'telescope')
    if has_telescope then
      require('telescope.builtin').grep_string({
        search=vim.fn.input("Grep For > ")
      })
    end
  end
})

-- Format
setKey('n', l('n'), '', {
  noremap = true,
  callback = vim.lsp.buf.formatting,
})

-- ctrl+backspace and mac variant
setKey('i', '<C-H>', '<C-W>', opts)
setKey('i', '<M-backspace>', '<C-W>', opts)

-- C-^ is too hard
setKey('n', l('b'), '<C-^>', opts)

-- Terminal
setKey('t', '<C-[>', '<C-\\><C-n>', opts)

-- Register Stuff
setKey('x', l('p'), '"_dP', opts)
setKey('n', l('y'), '"+y', opts)
setKey('v', l('y'), '"+y', opts)
setKey('n', l('d'), '"_d', opts)
setKey('v', l('d'), '"_d', opts)

-- Yank to EOL
setKey('n', 'Y', 'y$', opts)

-- Keep cursor on same line when searching/J-ing
setKey('n', 'n', 'nzzzv', opts)
setKey('n', 'N', 'Nzzzv', opts)
setKey('n', 'J', 'mzJ`z', opts)

-- Undo breakpoints
local chars = { ',', '.' }

for _, char in ipairs(chars) do
  setKey('i', char, char .. '<C-g>u', opts)
end

-- Jumplist mutations
local nore_expr = { noremap = true, silent = true, expr = true }
setKey('n', 'k', '(v:count > 5 ? "m\'" . v:count : "") . \'k\'', nore_expr)
setKey('n', 'j', '(v:count > 5 ? "m\'" . v:count : "") . \'j\'', nore_expr)

-- Moving Text
setKey('v', 'J', ":m '>+1<cr>gv=gv", opts)
setKey('v', 'K', ":m '>-2<cr>gv=gv", opts)
-- setKey('i', '<C-j>', '<esc>:m .+1<cr>==a', nore_silent)
-- setKey('i', '<C-k>', '<esc>:m .-2<cr>==a', nore_silent)
-- setKey('n', l('J'), ':m .+1<cr>==', nore_silent)
-- setKey('n', l('K'), ':m .-2<cr>==', nore_silent)

-- Quickfix
setKey('n', '<C-j>', '<cmd>cnext<cr>zz', opts)
setKey('n', '<C-k>', '<cmd>cprev<cr>zz', opts)
setKey('n', '<C-q>', '', {
  noremap = true,
  callback = require('eli.qfl').toggle
})

-- Scratch
setKey('n', l('s'), '', {
  noremap = true,
  callback = require('eli.scratch').scratch
})

local has_harpoon, _ = pcall(require, 'harpoon')
if not has_harpoon then
  return
end

local mark = require'harpoon.mark'
local ui = require'harpoon.ui'

vim.api.nvim_set_keymap('n', '<leader>ha', '', {
  noremap = true,
  silent = true,
  callback = mark.add_file
})

vim.api.nvim_set_keymap('n', '<leader>hh', '', {
  noremap = true,
  silent = true,
  callback = ui.toggle_quick_menu
})

for i = 1, 9 do
  vim.api.nvim_set_keymap('n', '<leader>h'..i, '', {
    noremap = true,
    silent = true,
    callback = function()
      ui.nav_file(i)
    end
  })
end
