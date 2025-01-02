local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.splitright = true
opt.splitbelow = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
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

opt.updatetime = 50
opt.colorcolumn = "100"

opt.backspace = "indent,eol,start"

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.diagnostic.config({
  signs = true,
  underline = {
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  },
  severity_sort = true,
})
