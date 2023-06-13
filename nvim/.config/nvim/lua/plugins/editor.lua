return {
    "tpope/vim-sleuth",
    {
        "numToStr/Comment.nvim",
        lazy = true,
        config = true
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>t", vim.cmd.TroubleToggle, desc = "[T]rouble" }
        }
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true
    },
}
