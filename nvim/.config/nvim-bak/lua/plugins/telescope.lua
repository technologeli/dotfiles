return {
    "nvim-telescope/telescope.nvim",
    version = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup({
            defaults = {
                vimgrep_arguments = {
                    unpack(require("telescope.config").values.vimgrep_arguments),
                    "--hidden",
                    "--glob",
                    "!**/.git/*",
                }
            },
            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
            },

        })
    end,
    keys = {
        {
            "<leader><space>",
            function() require("telescope.builtin").buffers() end,
            desc =
            "[ ] Find existing buffers"
        },
        { "<C-p>",      function() require("telescope.builtin").git_files() end,   desc = "Search Git Files" },
        { "<leader>sf", function() require("telescope.builtin").find_files() end,  desc = "[S]earch [F]iles" },
        { "<leader>sh", function() require("telescope.builtin").help_tags() end,   desc = "[S]earch [H]elp" },
        { "<leader>sg", function() require("telescope.builtin").live_grep() end,   desc = "[S]earch by [G]rep" },
        { "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "[S]earch [D]iagnostics" },
        { "<leader>sk", function() require("telescope.builtin").keymaps() end,     desc = "[S]earch [K]eymaps" },
        { "<leader>sc", function() require("telescope.builtin").colorscheme() end, desc = "[S]earch [C]olorscheme" },
        { "<leader>st", function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end,
            "[S]earch [T]ext" },

    }
}
