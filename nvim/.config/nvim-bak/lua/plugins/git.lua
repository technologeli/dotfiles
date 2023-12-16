return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            }
        },
    },
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", vim.cmd.Git, desc = "[G]it [S]tatus" }
        }
    }
}
