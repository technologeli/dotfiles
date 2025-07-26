return {
	"https://codeberg.org/historia/simple-denote.nvim",
	opts = {
		ext = "md",             -- Note file extension (e.g. md, org, norg, txt)
		dir = "~/notes",        -- Notes directory (should already exist)
		add_heading = true,     -- Add a md/org heading to new notes
		retitle_heading = true, -- Replace the first line heading when retitling
	},
}
