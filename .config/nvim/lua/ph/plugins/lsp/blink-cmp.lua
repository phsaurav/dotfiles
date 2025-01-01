return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets", "saghen/blink.compat" },

    version = "*",

    opts = {
      keymap = {
        preset = "default",
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
      },
      completion = {
        ghost_text = {
          enabled = false,
        },
        menu = {
          winblend = 20,
          scrollbar = false,
        },
        documentation = {
          auto_show = true,
          window = {
            winblend = 20,
            scrollbar = true,
          },
        },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "obsidian",
          "obsidian_new",
          "obsidian_tags",
          "markdown"
        },
        providers = {
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
          },
          obsidian_new = {
            name = "obsidian_new",
            module = "blink.compat.source",
          },
          obsidian_tags = {
            name = "obsidian_tags",
            module = "blink.compat.source",
          },
          markdown = {
            name = "render-markdown",
            module = 'render-markdown.integ.blink',
            enabled = function()
              if vim.bo.filetype == "markdown" then
                return true  -- Return true for markdown files
              else
                return false -- Return false for non-markdown files
              end
            end
          }
        },
      },

      signature = {
        enabled = true,
        window = {
          winblend = 20,
          scrollbar = false,
        },
      },
    },
  }
}
