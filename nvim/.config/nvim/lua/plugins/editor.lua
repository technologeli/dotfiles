return {
    "tpope/vim-sleuth",
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = true
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>tp", "<cmd>Trouble workspace_diagnostics<cr>", desc = "[T]rouble [P]roject" },
            { "<leader>tt", "<cmd>Trouble todo<cr>",                  desc = "[T]rouble [T]odo" },
            { "<leader>tw", "<cmd>TroubleClose<cr>",                  desc = "Trouble Close" }
        }
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = true
    }
}
