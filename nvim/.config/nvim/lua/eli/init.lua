require("eli.lazy")
require("eli.keymaps")
require("eli.sets")

vim.cmd.colorscheme('catppuccin')

local selectionbg = "#181926"
local previewbg = "#1e2030"
local promptbg = "#24273a"

vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#c6a0f6" })

vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = selectionbg })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = selectionbg, bg = selectionbg })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = selectionbg })

vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { fg = selectionbg })
vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = promptbg })

vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#c6a0f6", bg = promptbg })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = promptbg, bg = promptbg })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = promptbg, bg = "#c6a0f6" })

vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = previewbg })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = previewbg, bg = previewbg })
vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = previewbg, bg = previewbg })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
