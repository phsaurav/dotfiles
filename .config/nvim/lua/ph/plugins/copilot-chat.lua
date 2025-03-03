return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = true, -- Only load when needed
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatTests",
      "CopilotChatFix",
      "CopilotChatOptimize",
    },
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        lazy = true,
        cmd = "Copilot",
        config = function()
          require("copilot").setup({
            suggestion = {
              enabled = false,
              auto_trigger = true
            },
            panel = { enabled = false },
            filetypes = {
              ["*"] = false -- Disable Copilot for all filetypes
            }
          })
        end
      },                                              -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    opts = {
      agent = 'copilot',
      model = 'claude-3.7-sonnet',
      show_help = true,  -- Shows help message as virtual lines when waiting for user input
      show_folds = true, -- Shows folds for sections in chat
      chat_autocomplete = false,
      mappings = {
        reset = {
          normal = '<C-l>',
          insert = '<C-l>',
        },
        jump_to_diff = {
          normal = '<leader>cj',
        },
        quickfix_diffs = {
          normal = '<leader>cq',
        },
        show_diff = {
          normal = '<leader>cd',
        },
        show_info = {
          normal = '<leader>ci',
        },
        show_context = {
          normal = 'gc',
        },
        show_help = {
          normal = '<leader>ch',
        },
      },
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.4,         -- fractional width of parent, or absolute width in columns when > 1
      },
    },

    keys = {
      { "<leader>ch", ":CopilotChatToggle<CR> ", desc = "CopilotChat - Ask question" },
      {
        "<leader>cp",
        function()
          local chat = require("CopilotChat")
          chat.toggle({
            window = {
              layout = 'float',
              width = 0.7,
              height = 0.9,
              row = 1,
              border = "rounded",
            },
          })
          vim.cmd [[hi NormalFloat guibg=NONE]]
        end,
        desc = "CopilotChat - Ask question"
      },
      { "<leader>ce", ":CopilotChatExplain<CR>", desc = "CopilotChat - Explain code" },
      { "<leader>cf", ":CopilotChatFix<CR>",     desc = "CopilotChat - Explain code" },
      -- { "<leader>co", ":CopilotChatOptimize<CR>", desc = "CopilotChat - Explain code" },
    },
  },
}
