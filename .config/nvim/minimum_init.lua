vim.cmd("set runtimepath+=~/.config/nvim") -- Adjust if your config is elsewhere

-- Load plugin manager (e.g., lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"epwalsh/obsidian.nvim",
		config = function()
			require("obsidian").setup({
				-- Add only the settings you want to test
				workspaces = {
					{
						name = "Obsidian-Test",
						path = "~/obsidian-vault",
					},
				},
			})
		end,
	},
})

