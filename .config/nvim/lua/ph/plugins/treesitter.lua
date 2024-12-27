return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			modules = {}, -- Leave empty unless you want to configure custom modules
			sync_install = false, -- Install parsers synchronously
			auto_install = true, -- Automatically install missing parsers
			ignore_install = {}, -- Parsers to ignore installing
			highlight = {
				enable = true, -- Enable syntax highlighting
			},
			indent = {
				enable = true, -- Enable indentation
			},
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"markdown",
				"markdown_inline",
				"json",
				"yaml",
				"bash",
				"go",
				"javascript",
				"python",
				"terraform",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>]",
					node_incremental = "<leader>]",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
