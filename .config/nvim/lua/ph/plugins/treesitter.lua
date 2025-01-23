return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      modules = {},         -- Leave empty unless you want to configure custom modules
      sync_install = false, -- Install parsers synchronously
      auto_install = true,  -- Automatically install missing parsers
      ignore_install = {},  -- Parsers to ignore installing
      highlight = {
        enable = true,      -- Enable syntax highlighting
        additional_vim_regex_highlighting = false,
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
        "latex",
        "html",
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
          -- Incremental Select
          init_selection = "<C-o>",
          node_incremental = "<C-o>",
          scope_incremental = false,
          node_decremental = "<C-i>",
        },
      },
    })
  end,
}
