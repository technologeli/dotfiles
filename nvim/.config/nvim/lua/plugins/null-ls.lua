return {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    config = function()
        require("null-ls").setup({
            sources = {
                require("null-ls").builtins.formatting.prettierd,
            }
        })
    end

}
