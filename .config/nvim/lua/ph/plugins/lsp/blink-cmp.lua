local dictionary_file = vim.fn.expand("~/Documents/Software/words.txt")

return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "saghen/blink.compat" }, -- Obsidian completion adapters
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

      -- Keep code completion lean; note-related providers belong to Markdown.
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          markdown = {
            inherit_defaults = true,
            "obsidian",
            "obsidian_new",
            "obsidian_tags",
            "markdown",
            "dictionary",
          },
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
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
            -- The dictionary is optional when syncing this config to another machine.
            enabled = function()
              return vim.fn.filereadable(dictionary_file) == 1
            end,
            opts = {
              dictionary_files = { dictionary_file },
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
    ft = "markdown",
    dependencies = { "saghen/blink.cmp" },
  },
}
