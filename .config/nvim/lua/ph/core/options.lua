local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Set cursor style
opt.guicursor = "n-v-c:block,i-ci-ve:hor50,r-cr:hor25,o:hor50"

opt.splitright = true
opt.splitbelow = true

opt.foldenable = false
opt.foldlevelstart = 99
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
-- Keep four-space defaults instead of filetype-specific two-space overrides.
vim.g.yaml_recommended_style = 0
vim.g.sass_recommended_style = 0
opt.autoindent = true
opt.smartindent = true

opt.wrap = true

opt.swapfile = false
opt.backup = false
--opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
--opt.undofile = true

-- opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true  -- Use smartcase logic

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.cmdheight = 0
opt.updatetime = 50
opt.colorcolumn = "100"

opt.backspace = "indent,eol,start"

vim.opt.dictionary:append("/usr/share/dict/words")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘ ",
      [vim.diagnostic.severity.WARN] = "⚠ ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = "ℹ ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- Auto-reload files changed outside of Neovim
vim.opt.autoread = true
-- Trigger checktime when these events fire (cursor moves, focus gained, etc.)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
-- Notify when a file has been changed and reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})
