return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    vim.opt.list = true
    vim.opt.listchars = {
      tab = " ⋅", -- exactly two characters: a space and "⋅"
      multispace = " ⋅",
      space = " ",
      eol = " ",
      trail = " ",
      extends = " ",
      precedes = " ",
      nbsp = " ",
    }
    local highlight = {
      "CursorColumn",
      "Whitespace",
      "IndentBlanklineChar",
      -- "RainbowYellow",
      -- "RainbowBlue",
      -- "RainbowOrange",
      -- "RainbowGreen",
      -- "RainbowViolet",
      -- "RainbowCyan",
    }

    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "CursorColumn", { fg = "#FFA759" })
      vim.api.nvim_set_hl(0, "Whitespace", { fg = "#FFA759" })
      vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#FFA759" })
      -- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      -- vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      -- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      -- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      -- vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      -- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      -- vim.api.nvim_set_hl(0, "MyScopeHighlight", { fg = "#FC5CB9" })
    end)

    require("ibl").setup({
      indent = { highlight = "IndentBlanklineChar", char = " " },
      whitespace = {
        highlight = "LineNr",
        remove_blankline_trail = false,
      },
      scope = {
        enabled = true,
        char = "│",
        show_start = false,
        show_end = false,
        injected_languages = true,
        highlight = highlight,
        priority = 1024,
        include = {
          node_type = {
            ["*"] = {
              "^argument",
              "^expression",
              "^for",
              "^if",
              "^import",
              "^type",
              "arguments",
              "block",
              "bracket",
              "declaration",
              "field",
              "func_literal",
              "function",
              "import_spec_list",
              "list",
              "return_statement",
              "short_var_declaration",
              "statement",
              "switch_body",
              "try",
              "block_mapping_pair",
            },
          },
        },
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "*oil*",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "asm",
        },
      },
    })
  end,
  main = "ibl",
}
