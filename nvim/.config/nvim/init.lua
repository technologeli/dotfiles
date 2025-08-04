vim.opt.winborder = "rounded"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<ESC>", ":nohlsearch<CR>", { silent = true })

vim.pack.add({
	{ src = "https://github.com/morhetz/gruvbox" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
})

require("oil").setup({
	view_options = { show_hidden = true },
})
vim.keymap.set("n", "-", ":Oil<CR>")

require("mini.pick").setup({
	options = { content_from_bottom = true }
})
vim.keymap.set("n", "<leader><leader>", ":Pick buffers<CR>")
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")

local function pick_dotfiles()
	MiniPick.start({
		source = {
			items = vim.fn.systemlist("rg --hidden --files --glob '!.git' " .. vim.fn.expand("~/dotfiles")),
			name = "Dotfiles"
		},
		action = function(item)
			vim.cmd("edit " .. item)
		end
	})
end
vim.keymap.set("n", "<leader>c", pick_dotfiles)

local function pick_notes()
	MiniPick.start({
		source = {
			items = vim.fn.systemlist("rg --files " .. vim.fn.expand("~/notes")),
			name = "Notes"
		},
		action = function(item)
			vim.cmd("edit " .. item)
		end
	})
end
vim.keymap.set("n", "<leader>nf", pick_notes)

vim.lsp.enable({ "lua_ls", "clangd" })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.cmd("colorscheme gruvbox")


local function slugify(str)
	-- Convert to lowercase, remove punctuation, replace spaces with hyphens
	str = str:lower():gsub("[^%w%s]", ""):gsub("%s+", "-")
	return str
end

local function get_timestamp()
	return os.date("%Y%m%dT%H%M")
end

local denote_directory = vim.fn.expand("~/notes")
local function create_note()
	vim.ui.input({ prompt = "Title: " }, function(title)
		local filename = get_timestamp()
		if title == nil then
			return
		end

		if title ~= "" then
			filename = filename .. "--" .. slugify(title)
		end

		vim.ui.input({ prompt = "Tags: " }, function(tags)
			if tags and tags ~= "" then
				local tag_str = tags:gsub("%s+", ""):gsub(",", "_")
				filename = filename .. "__" .. tag_str
			end

			filename = filename .. ".md"

			vim.cmd("edit " .. vim.fs.joinpath(denote_directory, filename))
		end)
	end)
end
vim.keymap.set("n", "<leader>nn", create_note)

local uv = vim.loop

local function is_created_today(name)
	local today = os.date("*t")

	return tonumber(string.sub(name, 1, 4)) == today.year
		and tonumber(string.sub(name, 5, 6)) == today.month
		and tonumber(string.sub(name, 7, 8)) == today.day
end

local function today()
	local files = {}
	local handle = uv.fs_scandir(denote_directory)
	if not handle then
		print("Directory not found: " .. denote_directory)
		return
	end

	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then break end
		if type == 'file' and name:find("_journal") then
			local filepath = vim.fs.joinpath(denote_directory, name)
			local stat = uv.fs_stat(filepath)
			if is_created_today(name) then
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
vim.keymap.set("n", "<leader>nt", today)


require('render-markdown').setup({
	heading = { enabled = false },
})


require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	}
})

require("supermaven-nvim").setup({
	keymaps = {
		-- <C-j> = accept word
		clear_suggestion = "<C-s>",
	},
	ignore_filetypes = { "markdown" }
})
