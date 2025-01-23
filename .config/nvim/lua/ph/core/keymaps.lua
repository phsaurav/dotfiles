vim.g.mapleader = " "

local keymap = vim.keymap
local opt = { noremap = true, silent = true }

keymap.set("i", "kj", "<Esc>")
keymap.set("n", "<leader>eo", vim.cmd.Ex) -- Open Explorer

keymap.set("n", "<leader>dd", ":nohl<CR>")
keymap.set({ "n", "v" }, "c", '"_c', { noremap = true })
keymap.set({ "n", "v" }, "C", '"_C', { noremap = true })
keymap.set("n", "cc", '"_cc')


keymap.set("n", "go", "<C-o>")
keymap.set("n", "gi", "<C-i>")

-- Movement
keymap.set("n", "L", "16kzz", opt)
keymap.set("n", "H", "16jzz", opt)
keymap.set("n", "gl", "<C-w>l", opt)
keymap.set("n", "gh", "<C-w>h", opt)
keymap.set("n", "gj", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "gk", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize splits incrementally
keymap.set("n", "<C-M-l>", ":vertical resize -2<CR>", { silent = true, desc = "Decrease width" })
keymap.set("n", "<C-M-h>", ":vertical resize +2<CR>", { silent = true, desc = "Increase width" })
keymap.set("n", "<C-M-j>", ":resize -2<CR>", { silent = true, desc = "Decrease height" })
keymap.set("n", "<C-M-k>", ":resize +2<CR>", { silent = true, desc = "Increase height" })

-- Replace
keymap.set("n", "gsw", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { noremap = true, silent = false })
keymap.set("v", "gsw", [[y:%s/<C-r>"//g<Left><Left>]], { noremap = true, silent = false })
keymap.set("v", "<C-c>", '"+y', opt)

keymap.set("v", "<Tab>", ">gv")
keymap.set("v", "<S-Tab>", "<gv")

-- Wrapper (Updated to work with autopair plugin)
keymap.set("x", "<leader>b", "<Esc>`>a)<Esc>`<i(<Esc>", { noremap = true, desc = "Wrap with parentheses" })
keymap.set("x", "<leader>{", "<Esc>`>a}<Esc>`<i{<Esc>", { noremap = true, desc = "Wrap with curly braces" })
keymap.set("x", "<leader>[", "<Esc>`>a]<Esc>`<i[<Esc>", { noremap = true, desc = "Wrap with square brackets" })
keymap.set("x", "<leader>'", "<Esc>`>a'<Esc>`<i'<Esc>", { noremap = true, desc = "Wrap with single quotes" })
keymap.set("x", '<leader>"', '<Esc>`>a"<Esc>`<i"<Esc>', { noremap = true, desc = "Wrap with double quotes" })

keymap.set({ "n", "v" }, "g;", "%")

keymap.set({ "n", "v" }, "<leader>wd", "<Cmd>lua toggle_virtual_text()<CR>", opt)
keymap.set({ "n", "v" }, "<leader>w", "<Cmd>lua Save_file()<CR>", opt)
vim.keymap.set({ "n", "v" }, "<leader>s", function()
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd("wa")
  else
    vim.ui.input({ prompt = "filename: " }, save_file)
  end
end)

keymap.set("n", "<leader>fx", "<Cmd>lua quickfix()<CR>", opt)
keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opt)
keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opt)
keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opt)
keymap.set("n", "<leader>cc", "<Cmd>cclose<CR>", opt)
keymap.set("n", "<leader>co", "<Cmd>copen<CR>", opt)
keymap.set("n", "<leader>cn", "<Cmd>cnext<CR>", opt)
keymap.set("n", "<leader>cp", "<Cmd>cprev<CR>", opt)

keymap.set("n", "<leader>q", ":q<CR>")
keymap.set("n", "<leader>Q", ":q!<CR>")
-- Open the selected file in a horizontal split
keymap.set("n", "<leader>sv", ":split<CR>", opt)

-- Open the selected file in a vertical split
keymap.set("n", "<leader>sh", ":vsplit<CR>", opt)

-- Buffer Manipulation
keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

keymap.set("n", "<leader>tc", ":TabnineChat<CR>", { noremap = true, silent = true, desc = "Start Tabnine Chat" })

-- Nvim Terminal
keymap.set("n", "<leader>tt", ":terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in new buffer" })
keymap.set("n", "<leader>th", ":vsplit | terminal<CR>",
  { noremap = true, silent = true, desc = "Open terminal in vertical split" })
keymap.set("n", "<leader>tv", ":split | terminal<CR>",
  { noremap = true, silent = true, desc = "Open terminal in horizontal split" })
keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Close all buffers except the current one
keymap.set("n", "<leader>bo", function()
  local current_buffer = vim.api.nvim_get_current_buf()
  local all_buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(all_buffers) do
    if buf ~= current_buffer and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'modified') == false then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end

  vim.cmd("redraw")
  print("Closed all buffers except the current one")
end, { noremap = true, silent = true, desc = "Close all buffers except current" })

-- Delete buffer
keymap.set("n", "<leader>bd", function()
  local current_buffer = vim.api.nvim_get_current_buf()
  local next_buffer = vim.fn.bufnr("#")

  if next_buffer ~= -1 and vim.api.nvim_buf_is_valid(next_buffer) then
    vim.api.nvim_set_current_buf(next_buffer)
  else
    vim.cmd("bnext")
  end

  vim.api.nvim_buf_delete(current_buffer, { force = false })
end, { noremap = true, silent = true, desc = "Delete current buffer" })
-- Switch to alternate buffer
keymap.set("n", "<leader>ba", "<cmd>b#<cr>", {
  noremap = true,
  silent = true,
  desc = "Switch to alternate buffer"
})

-- Record macro
keymap.set("n", "<leader>m", "q", { noremap = true, silent = true, desc = "Start/stop macro recording" })

-- Map <Cmd> + A to select all in Neovim
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })      -- Normal mode
keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" }) -- Insert mode
keymap.set("v", "va", "<Esc>ggVG", { desc = "Select all" })
keymap.set("n", "<D-a>", "ggVG", { noremap = true, silent = true })
keymap.set('v', '<D-c>', '"+y', { noremap = true, silent = true })

keymap.set({ "n", "v" }, "<leader>pb", function()
  vim.cmd("cd ~/Documents/Play_Ground/Blank/")
  print("Directory changed to ~/Documents/Play_Ground/Blank/")
end, opt)
keymap.set("n", "<C-s>", function()
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

keymap.set("n", "<leader>yf", function()
  local relative_path = vim.fn.expand("%")
  vim.fn.setreg("+", relative_path)
  print("Copied to clipboard: " .. relative_path)
end, { desc = "Copy relative file path to clipboard" })

save_file = function(path)
  local ok, err = pcall(vim.cmd.w, path)

  if not ok then
    -- clear `vim.ui.input` from cmdline to make space for an error
    vim.cmd.redraw()
    vim.notify(err, vim.log.levels.ERROR, {
      title = "error while saving file",
    })
  end
end
