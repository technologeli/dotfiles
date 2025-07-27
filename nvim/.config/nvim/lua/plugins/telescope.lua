return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
		},
		config = function()
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local insert_path = function(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				if selection and selection.path then
					vim.api.nvim_put({ selection.path }, 'c', true, true)
				elseif selection and selection.filename then
					vim.api.nvim_put({ selection.filename }, 'c', true, true)
				elseif type(selection[1]) == "string" then
					vim.api.nvim_put({ selection[1] }, 'c', true, true)
				end
			end

			require("telescope").setup {
				defaults = {
					file_ignore_patterns = { ".git/" },
					mappings = {
						i = {
							["<C-y>"] = insert_path,
						},
						n = {
							["<C-y>"] = insert_path,
						}
					}
				},
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
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Search Buffers" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sr", builtin.lsp_references, { desc = "[S]earch [R]eferences" })
			vim.keymap.set("n", "<leader>sc", function()
				builtin.find_files {
					cwd = "~/dotfiles"
				}
			end, { desc = "[S]earch [C]onfig" })
			vim.keymap.set("n", "<leader>sp", function()
				builtin.find_files {
					cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
				}
			end, { desc = "[S]earch [P]ackages" })
			vim.keymap.set("n", "<leader>nf", function()
				builtin.find_files {
					cwd = "~/notes",
				}
			end)

			require("config.telescope.multigrep").setup()
		end
	}
}
