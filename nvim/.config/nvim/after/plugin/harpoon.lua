local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = '[A]dd File to Harpoon' })
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = 'Toggle Harpoon Menu' })

vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = 'Harpoon File 1' })
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = 'Harpoon File 2' })
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = 'Harpoon File 3' })
