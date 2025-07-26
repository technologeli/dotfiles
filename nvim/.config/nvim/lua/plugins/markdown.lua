return { 
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = {
				width = "block",
				position = "inline",
				left_pad = 2,
				right_pad = 2,
			}
		},
	}
}
