vim.g.mapleader = " "

local keymap = vim.keymap
local opt = { noremap = true, silent = true }

keymap.set("i", "kj", "<Esc>")
keymap.set("n", "<leader>eo", vim.cmd.Ex) -- Open Explorer

keymap.set("n", "<leader>dd", ":nohl<CR>")
keymap.set("n", "d", '"_d')
keymap.set("n", "D", '"_D')
keymap.set("n", "dd", '"_dd')

keymap.set("n", "go", "<C-o>")
keymap.set("n", "gi", "<C-i>")

-- Movement
keymap.set("n", "L", "16kzz", opt)
keymap.set("n", "H", "16jzz", opt)
keymap.set("n", "gl", "<C-w>l", opt)
keymap.set("n", "gh", "<C-w>h", opt)
keymap.set("n", "gj", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "gk", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Replace
keymap.set("n", "gsw", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { noremap = true, silent = false })
keymap.set("v", "gsw", [[y:%s/<C-r>"//g<Left><Left>]], { noremap = true, silent = false })
keymap.set("v", "<C-c>", '"+y', opt)

keymap.set("v", "<Tab>", ">gv")
keymap.set("v", "<S-Tab>", "<gv")

-- Wrapper
keymap.set("x", "<leader>b", "xi()<Esc>P")
keymap.set("x", "<leader>{", "c{}<Esc>P")
keymap.set("x", "<leader>[", "c[]<Esc>P")
keymap.set("x", "<leader>'", "c''<Esc>P")
keymap.set("x", '<leader>"', 'c""<Esc>P')

keymap.set({ "n", "v" }, "g;", "%")

keymap.set({ "n", "v" }, "<leader>wd", "<Cmd>lua toggle_virtual_text()<CR>", opt)
keymap.set({ "n", "v" }, "<leader>w", "<Cmd>lua Save_file()<CR>", opt)
keymap.set("n", "<leader>fx", "<Cmd>lua quickfix()<CR>", opt)
keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opt)
keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opt)
keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opt)
keymap.set("n", "<leader>cc", "<Cmd>cclose<CR>", opt)
keymap.set("n", "<leader>co", "<Cmd>copen<CR>", opt)
keymap.set("n", "<leader>cn", "<Cmd>cnext<CR>", opt)
keymap.set("n", "<leader>cp", "<Cmd>cprev<CR>", opt)

keymap.set("n", "<leader>q", ":q<CR>")
-- Open the selected file in a horizontal split
keymap.set("n", "<leader>sv", ":split<CR>", opt)

-- Open the selected file in a vertical split
keymap.set("n", "<leader>sh", ":vsplit<CR>", opt)

-- Map <Cmd> + A to select all in Neovim
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" }) -- Normal mode
keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" }) -- Insert mode
keymap.set("v", "va", "<Esc>ggVG", { desc = "Select all" })
keymap.set("n", "<D-a>", "ggVG", { noremap = true, silent = true })

keymap.set({ "n", "v" }, "<leader>pb", function()
	vim.cmd("cd ~/Documents/Play_Ground/Blank/")
	print("Directory changed to ~/Documents/Play_Ground/Blank/")
end, opt)
keymap.set("n", "<C-s>", function()
	local save_file = function(path)
		local ok, err = pcall(vim.cmd.w, path)

		if not ok then
			-- clear `vim.ui.input` from cmdline to make space for an error
			vim.cmd.redraw()
			vim.notify(err, vim.log.levels.ERROR, {
				title = "error while saving file",
			})
		end
	end

	if vim.api.nvim_buf_get_name(0) ~= "" then
		save_file()
	else
		vim.ui.input({ prompt = "filename: " }, save_file)
	end
end)

keymap.set("n", "<leader>yd", function()
	local cwd = vim.fn.getcwd()
	vim.fn.setreg("+", cwd)
	print("Copied to clipboard: " .. cwd)
end, { desc = "Copy current directory path to clipboard" })
