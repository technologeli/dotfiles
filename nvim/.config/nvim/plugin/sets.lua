local o = vim.opt

-- Tabs
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.softtabstop = 2
o.tabstop = 2

-- Line Numbers
o.number = true
o.relativenumber = true

-- Search
o.hlsearch = false
o.incsearch = true

-- Backups and Undos
o.backup = false
o.swapfile = false
o.undofile = true
o.undodir = '/home/eli/.local/share/nvim/undo/'

-- Split below and right
o.splitbelow = true
o.splitright = true

-- Hide buffers
o.hidden = true

-- ???????
o.formatoptions = o.formatoptions
  - 'a'
  - 't'
  + 'c'
  + 'q'
  - 'o'
  + 'r'
  + 'n'
  + 'j'
  - '2'

-- Completion Stuff
o.completeopt = "menu,menuone,noselect"

-- Appearance
o.colorcolumn = '80'
o.cursorline = true
o.mouse = 'a'
o.scrolloff = 8
o.showmode = false -- the "-- INSERT --" thing
o.signcolumn = 'yes'
o.termguicolors = true
o.wrap = false
