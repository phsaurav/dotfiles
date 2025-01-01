return {
  "Shatur/neovim-ayu",
  as = "ayu",
  priority = 1000,
  config = function()
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
        VertSplit = { bg = "None" },
        Keyword = { italic = true, fg = "#ffaf00" },
        border = { bg = "None", fg = "None" }
      },
    })
    vim.cmd("colorscheme ayu")
  end,
}
