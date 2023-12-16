return {
    { "morhetz/gruvbox", lazy = true },
    { "folke/tokyonight.nvim", lazy = true },
    { "navarasu/onedark.nvim", lazy = true },
    { "catppuccin/nvim", name = "catppuccin", lazy = false },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = false,
                theme = 'catppuccin',
                component_separators = '|',
                section_separators = '',
            },
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,

        }
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 90,
                options = {
                    number = true,
                    relativenumber = true,
                }
            },
        },
        keys = {
            {
                "<leader>z",
                function()
                    require("zen-mode").toggle()
                    vim.wo.wrap = false
                end,
                desc = '[Z]en Mode'
            }
        }
    }
}
