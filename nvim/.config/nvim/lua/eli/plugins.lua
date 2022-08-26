local fn = vim.fn

local installPath = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

-- auto install packer
if fn.empty(fn.glob(installPath)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      installPath,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

local ag = vim.api.nvim_create_augroup
local ac = vim.api.nvim_create_autocmd

-- re source this file on save
local pack = ag('pack', { clear = true })
ac('BufWritePost', {
  pattern = 'plugins.lua',
  command = 'source <afile> | PackerSync',
  group = pack
})

local ok, packer = pcall(require, 'packer')
if not ok then return end

return packer.startup(function (use)
  use 'wbthomason/packer.nvim'

  -- Theme
  use 'morhetz/gruvbox'
  use 'tjdevries/colorbuddy.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  -- use 'pantharshit00/vim-prisma'

  -- Tree files
  use 'kyazdani42/nvim-tree.lua'

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-context'
  use { 'nvim-treesitter/playground', opt = true, cmd = 'TSPlaygroundToggle' }

  -- LSP
  use 'neovim/nvim-lspconfig'

  -- CMP
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/nvim-cmp'
  use 'onsails/lspkind-nvim'
  use 'ray-x/lsp_signature.nvim'

  -- Snip
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Telescope
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

  -- Git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'stsewd/fzf-checkout.vim'

  -- Colors
  use 'norcalli/nvim-colorizer.lua'

  -- Harpoon
  use 'ThePrimeagen/harpoon'

  -- Binding bad
  use 'folke/which-key.nvim'

  -- Focus
  use { 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode' }

  -- Formatting
  use { 'sbdchd/neoformat', opt = true, cmd = 'Neoformat' }

  -- Markdown Preview
  use {'iamcco/markdown-preview.nvim', run = 'cd app && npm install', cmd = 'MarkdownPreview'}

  -- ()
  use 'rstacruz/vim-closer'

  -- --
  use 'numToStr/Comment.nvim'

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
