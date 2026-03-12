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
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/3rd/image.nvim" },
})

require("image").setup({
  backend = "kitty",
  processor = "magick_cli", -- or "magick_rock"
  integrations = {
    markdown = {
      enabled = true,
      download_remote_images = false,
      only_render_image_at_cursor = false,
      filetypes = { "markdown" },
    },
  },
})

-- to update, run :lua vim.pack.update() then :w

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

require('render-markdown').setup({
	heading = { enabled = false },
	code = {
		style = 'normal',
		border = 'thick',
	},
})

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	}
})

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
