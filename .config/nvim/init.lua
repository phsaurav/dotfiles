require("ph.core")
require("ph.lazy")

require("ayu").setup({
	mirage = true,
	terminal = true,
	overrides = {
		Normal = { bg = "None" },
		ColorColumn = { bg = "None" },
		SignColumn = { bg = "None" },
		Folded = { bg = "None" },
		FoldColumn = { bg = "None" },
		CursorLine = { bg = "None" },
		CursorColumn = { bg = "None" },
		WhichKeyFloat = { bg = "None" },
		VertSplit = { fg = "NONE", bg = "NONE" },
		LineNr = { fg = "#5c422e", bg = "NONE" },
		CursorLineNr = { fg = "#ffaf00", bg = "NONE" },
		Keyword = { italic = true, fg = "#FFA759" },
		Parameter = { italic = true, fg = "#ffaf00" },
	},
})

vim.cmd.colorscheme("ayu")
