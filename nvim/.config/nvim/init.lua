vim.opt.mouse = ""
vim.opt.colorcolumn = "80"
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
vim.opt.termguicolors = true
vim.opt.scrollback = 1000000
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", "mmgqap'm") -- get marked
vim.keymap.set("n", "<C-z>", "1z=e")
vim.keymap.set("i", "<C-z>", "<ESC>1z=ea")
vim.keymap.set("n", "<ESC>", ":nohlsearch<CR>", { silent = true })

vim.pack.add({
	{ src = "https://github.com/morhetz/gruvbox" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
})
-- to update, run :lua vim.pack.update() then :w

require("snacks").setup({
	image = {
		env = { SNACKS_GHOSTTY = true },
		math = { enabled = true },
	}
})


-- npm install -g tree-sitter-cli
require("nvim-treesitter").setup({
	highlight = {
		enable = true,
	}
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
	})
end
vim.keymap.set("n", "<leader>c", pick_dotfiles)

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.lsp.config("basedpyright", {
	cmd = { "uv", "run", "basedpyright-langserver", "--stdio" }
})
vim.lsp.enable({ "lua_ls", "clangd", "zls", "basedpyright" })

vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.cmd("colorscheme gruvbox")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit", "tex" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_us" }
	end,
})

vim.keymap.set("n", "<leader>h1", "I# ")
vim.keymap.set("n", "<leader>h2", "I## ")
vim.keymap.set("n", "<leader>h3", "I### ")
vim.keymap.set("n", "<leader>h4", "I#### ")
vim.keymap.set("n", "<leader>h5", "I##### ")
vim.keymap.set("n", "<leader>h6", "I###### ")

local function paragraph_end_insert()
	local last_line = vim.fn.line("$")
	vim.cmd("normal! }")
	local cur_line = vim.fn.line(".")
	-- If we jumped to the last line, just append there; otherwise go up one
	if cur_line < last_line then
		vim.cmd("normal! k")
	end
	vim.cmd("normal! A")
	vim.cmd("startinsert!")
end

local function paragraph_start_insert()
	local first_line = 1
	vim.cmd("normal! {")
	local cur_line = vim.fn.line(".")
	-- If we jumped to the first line, just insert there; otherwise go down one
	if cur_line > first_line then
		vim.cmd("normal! j")
	end
	vim.cmd("normal! I")
	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>a", paragraph_end_insert)
vim.keymap.set("n", "<leader>i", paragraph_start_insert)

require("flash").setup({
	prompt = { enabled = false }
})

vim.keymap.set({ "n", "x", "o" }, "<leader>s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "<leader>v", function() require("flash").treesitter() end) -- v for visual
vim.keymap.set("o", "r", function() require("flash").remote() end)
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end)
vim.keymap.set("c", "<C-s>", function() require("flash").toggle() end)

-- set makeprg or set mp
vim.keymap.set("n", "<leader>m", ":make<CR>")

vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.api.nvim_create_user_command("Rg", function(opts)
	vim.cmd("sil grep " .. (opts.args or ""))
	vim.cmd("copen")
end, { nargs = "*" })

vim.keymap.set("n", "<leader>e", ":detach<CR>")
vim.keymap.set("n", "<leader>t", ":terminal<CR>")

vim.keymap.set("n", "<leader>r", function()
	local old = vim.api.nvim_buf_get_name(0)
	vim.ui.input({ prompt = "Rename buffer " .. old .. " to: " }, function(new)
		if new and new ~= "" and new ~= old then
			vim.fn.rename(old, new)
			vim.cmd("file " .. vim.fn.fnameescape(new))
		end
	end)
end)

local function pick_ssh_host()
	local home = os.getenv("HOME")
	local ssh_config = home .. "/.ssh/config"
	local hosts = {}

	-- 1. Read and parse the .ssh/config
	local f = io.open(ssh_config, "r")
	if not f then
		vim.notify("Could not find .ssh/config", vim.log.levels.ERROR)
		return
	end

	for line in f:lines() do
		local host_line = line:match("^%s*[Hh][Oo][Ss][Tt]%s+(.*)")
		if host_line then
			for host in host_line:gmatch("%S+") do
				if not host:find("[%*%?]") then
					table.insert(hosts, host)
				end
			end
		end
	end
	f:close()

	local MiniPick = require("mini.pick")
	MiniPick.start({
		source = {
			items = hosts,
			name = "SSH Hosts",
			-- This callback runs when an item is selected
			choose = function(item)
				vim.schedule(function()
					vim.cmd("edit oil-ssh://" .. item .. "/")
				end)
			end,
		},
	})
end

local function ssh(host)
	vim.cmd("edit oil-ssh://" .. host .. "/")
end

vim.api.nvim_create_user_command("SSH", function(opts)
	if #opts.fargs > 1 then
		vim.notify("Usage: :SSH or :SSH <host>")
	elseif #opts.fargs == 1 then
		ssh(opts.fargs[1])
	else
		pick_ssh_host()
	end
end, { nargs = "*" })

function _G.MyTabLine()
	local s = ""
	local tabs = vim.api.nvim_list_tabpages() -- Get handles for all tabs

	for i, handle in ipairs(tabs) do
		local is_current = (handle == vim.api.nvim_get_current_tabpage())
		s = s .. (is_current and "%#TabLineSel#" or "%#TabLine#")
		s = s .. "%" .. i .. "T" -- Allow clicking tab index 'i'

		-- Correct way to get a variable from a specific tab handle
		local success, custom_name = pcall(vim.api.nvim_tabpage_get_var, handle, "tabname")
		local label = ""

		if success and custom_name ~= "" then
			label = custom_name
		else
			-- Fallback: Get name of the first window's buffer in that tab
			local win = vim.api.nvim_tabpage_get_win(handle)
			local buf = vim.api.nvim_win_get_buf(win)
			local bufname = vim.api.nvim_buf_get_name(buf)
			label = (bufname == "") and "[No Name]" or vim.fn.fnamemodify(bufname, ":t")
		end

		s = s .. " " .. i .. ":" .. label .. " "
	end

	return s .. "%#TabLineFill#%T"
end

vim.opt.tabline = "%!v:lua.MyTabLine()"

vim.api.nvim_create_user_command('Tabname', function(opts)
	vim.t.tabname = opts.args
	vim.cmd('redrawtabline')
end, { nargs = 1 })

vim.keymap.set("n", "<leader>T", ":tabnew<cr>")
vim.keymap.set("n", "<leader>W", ":tabclose<cr>")
vim.keymap.set("n", "<leader>R", ":Tabname ")
