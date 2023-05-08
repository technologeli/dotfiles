vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>")
vim.keymap.set("n", "<leader>b", "<C-^>", { desc = 'Previous [B]uffer' })

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = '[E]xplorer' })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Switch line below' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Switch line above' })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

-- asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ timeout_ms = 2000 }) end, { desc = '[F]ormat file' })

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = 'QuickFixList Next' })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = 'QuickFixList Previous' })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = 'LocalList Next' })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = 'LocalList Previous' })

vim.keymap.set("n", "<C-s>", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = 'Replace all instances' })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, { desc = 'Make file executable' })

vim.keymap.set('i', '<C-H>', '<C-W>', { desc = 'Delete Word' })
vim.keymap.set('i', '<M-backspace>', '<C-W>', { desc = 'Delete Word (Mac)' })
