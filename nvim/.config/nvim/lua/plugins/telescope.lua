return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
		},
		config = function()
			require("telescope").setup {
				pickers = {
					help_tags = {
						theme = "ivy"
					},
					find_files = {
						theme = "ivy",
						hidden = true,
					}
				}
			}
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sr", builtin.lsp_references, { desc = "[S]earch [R]eferences" })
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files {
					cwd = vim.fn.stdpath("config")
				}
			end, { desc = "[S]earch [N]eovim Config" })
			vim.keymap.set("n", "<leader>sp", function()
				builtin.find_files {
					cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
				}
			end, { desc = "[S]earch [P]ackages" })

			require("config.telescope.multigrep").setup()
		end
	}
}
