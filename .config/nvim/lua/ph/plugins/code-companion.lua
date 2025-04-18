return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionChat Toggle"
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "openrouter",
          slash_commands = {
            ["file"] = {
              -- Location to the slash command in CodeCompanion
              callback = "strategies.chat.slash_commands.file",
              description = "Select a file using Telescope",
              opts = {
                provider = "telescope",
                contains_code = true,
              },
            },
            ["buffer"] = {
              -- Location to the slash command in CodeCompanion
              callback = "strategies.chat.slash_commands.buffer",
              description = "Select a file using Telescope",
              opts = {
                provider = "telescope",
                contains_code = true,
              },
            },
          },
        },
      },
      adapters = {
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              api_key = os.getenv("OPENROUTER_API_KEY"),
              url = "https://openrouter.ai/api",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "openai/o3-mini",
              },
            }
          })
        end,
      },
      default_adapter = "openrouter",
      window = {
        layout = "vertical", -- float|vertical|horizontal|buffer
        position = nil,      -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
        width = 0.40,
        relative = "editor",
        opts = {
          breakindent = true,
          cursorcolumn = false,
          cursorline = false,
          foldcolumn = "0",
          linebreak = true,
          list = false,
          numberwidth = 1,
          signcolumn = "no",
          spell = false,
          wrap = true,
        },
      },

      display = {
        chat = {
          intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
          show_header_separator = false,
          separator = "─", -- The separator between the different messages in the chat buffer
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = false, -- Open the chat buffer in insert mode?
        },
        action_palette = {
          width = .5,
          height = .5,
          prompt = "Prompt ",                   -- Prompt used for interactive LLM calls
          provider = "telescope",               -- default|telescope|mini_pick
          opts = {
            show_default_actions = true,        -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
      },
    })

    -- vim.keymap.set("n", "<leader>ch", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Open CodeCompanion chat" })

    -- vim.keymap.set("n", "<leader>cc", function()
    --   require("codecompanion").toggle({
    --     window = {
    --       layout = "float",
    --       width = 0.7,
    --       height = 0.9,
    --       row = 0.1,
    --       border = "rounded",
    --     },
    --   })
    --   vim.cmd [[hi NormalFloat guibg=NONE]]
    -- end, { desc = "CodeCompanion Chat - Floating window" })
    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.g.codecompanion_in_use = true
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
