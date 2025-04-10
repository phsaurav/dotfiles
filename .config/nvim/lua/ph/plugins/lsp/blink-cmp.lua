return {
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.compat" }, -- Move blink-cmp-dictionary out of here
    version = "1.*",

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
      cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
          }
        }
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
          "markdown",
          "dictionary",
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
            module = "render-markdown.integ.blink",
            enabled = function()
              if vim.bo.filetype == "markdown" then
                return true
              else
                return false
              end
            end,
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
            enabled = function()
              if vim.bo.filetype == "markdown" then
                return true  -- Enable dictionary only for markdown files
              else
                return false -- Disable for all other filetypes
              end
            end,
            opts = {
              dictionary_files = { vim.fn.expand("/Users/phsaurav/Documents/Software/words.txt") },
              max_items = 5,
            },
          },
        },

      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = {
        enabled = true,
        window = {
          winblend = 20,
          scrollbar = false,
        },
      },
    },
  },
  {
    "Kaiser-Yang/blink-cmp-dictionary",
    ft = "markdown",                       -- Load only for Markdown filetype
    dependencies = { "saghen/blink.cmp" }, -- Ensure blink.cmp is loaded first
  },
}
