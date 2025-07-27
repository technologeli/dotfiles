require("config.lazy")
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
vim.opt.conceallevel = 2

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
vim.opt.backup = false
vim.opt.swapfile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.guicursor = {
	"n-v-c:block-blinkon0",
	"i-ci-ve:ver25-blinkon0",
	"r-cr:hor20-blinkon0",
	"o:hor50-blinkon0",
}
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 10 -- minimum lines above and below cursor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false -- statusline replaces this
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- grn is rename
-- gra is code action
-- grr is references
-- gri is implementations
-- gd is definition

vim.keymap.set("n", "<leader>b", "<cmd>b#<CR>", { desc = "Previous [B]uffer" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Source current line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Source current lines" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Unhighlight search" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Switch line below" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Switch line above" })
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", '"_dP')

-- asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- Diagnostics
local goto_next = function() vim.diagnostic.jump { count = 1, float = true } end
local goto_prev = function() vim.diagnostic.jump { count = -1, float = true } end
vim.keymap.set("n", "[d", goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "\\f", goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "\\d", goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
vim.keymap.set("n", "<M-o>", "<cmd>copen<CR>")
vim.keymap.set("n", "<M-c>", "<cmd>cclose<CR>")

vim.keymap.set("i", "<C-H>", "<C-W>", { desc = "Delete Word" })
vim.keymap.set("i", "<M-backspace>", "<C-W>", { desc = "Delete Word (Mac)" })

-- From kickstart.nvim
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Prevent persistent undo files in /tmp",
	group = vim.api.nvim_create_augroup("no-tmp-persistent-undo", { clear = true }),
	pattern = { "/dev/*", "/tmp/*" },
	callback = function()
		vim.opt_local.undofile = false
	end,
})


vim.keymap.set({'n','v'}, '<leader>nn', ":Denote note<cr>",      { desc = "New note"         })
vim.keymap.set({'n','v'}, '<leader>nr', ":Denote title<cr>",     { desc = "Rename note"     })
vim.keymap.set({'n','v'}, '<leader>nk', ":Denote keywords<cr>",  { desc = "Change keywords"  })
vim.keymap.set({'n','v'}, '<leader>nz', ":Denote signature<cr>", { desc = "Change signature" })
vim.keymap.set({'n','v'}, '<leader>ne', ":Denote extension<cr>", { desc = "Change extension" })

local uv = vim.loop

local function is_created_today(ctime_sec)
	local file_date = os.date("*t", ctime_sec)
	local today = os.date("*t")

	return file_date.year == today.year
	and file_date.month == today.month
	and file_date.day == today.day
end

local function today(dir)
	local files = {}
	local handle = uv.fs_scandir(dir)
	if not handle then
		print("Directory not found: " .. dir)
		return
	end

	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then break end
		if type == 'file' and name:find("_journal") then
			local filepath = dir .. "/" .. name
			local stat = uv.fs_stat(filepath)
			if stat and is_created_today(stat.ctime.sec) then
				table.insert(files, { path = filepath, ctime = stat.ctime.sec })
			end
		end
	end

	if #files == 0 then
		print("No journal entry for today.")
		return
	end

	table.sort(files, function(a, b)
		return a.ctime > b.ctime
	end)

	local latest_file = files[1].path
	vim.cmd("edit " .. vim.fn.fnameescape(latest_file))
end
vim.keymap.set({'n','v'}, '<leader>nt', function() today("/home/eli/notes") end, { desc = "Go to today's note" })
