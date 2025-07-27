return {
	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = 'rafamadriz/friendly-snippets',

		-- use a release tag to download pre-built binaries
		version = 'v0.*',
		opts = {
			keymap = { preset = 'default' },
			enabled = function()
				return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
			end,
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono'
			},
			signature = { enabled = true }
		},
	},
}
