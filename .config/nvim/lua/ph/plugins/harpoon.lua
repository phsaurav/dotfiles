return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set(
			"n",
			"<leader>ha",
			mark.add_file,
			{ desc = "Harpoon: Add file" },
			{ noremap = true, silent = false }
		)
		vim.keymap.set(
			"n",
			"<leader>hh",
			ui.toggle_quick_menu,
			{ desc = "Harpoon: Toggle quick menu" },
			{ noremap = true, silent = false }
		)
		vim.keymap.set("n", "<leader>hj", function()
			ui.nav_file(1)
		end)
		vim.keymap.set("n", "<leader>hk", function()
			ui.nav_file(2)
		end)
		vim.keymap.set("n", "<leader>hl", function()
			ui.nav_file(3)
		end)
	end,
}