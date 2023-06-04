require("eli.packer")
require("eli.keymaps")
require("eli.sets")

vim.cmd.colorscheme('catppuccin')
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
