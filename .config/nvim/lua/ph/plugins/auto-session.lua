return {
  "rmagatti/auto-session",
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Downloads", "/" },
    -- log_level = 'debug',
    -- auto_restore_last_session = true,
    lazy_support = true,
    session_lens = {
      theme_conf = {
        border = true,
        layout_config = { -- As one example, can change width/height of picker
          width = 0.8,    -- percent of window
          height = 0.6,
        },
      },
      previewer = false,
      mappings = {
        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
        delete_session = { "i", "<C-D>" },
        copy_session = { "i", "<C-Y>" },
      },
    },
    post_restore_cmds = {
      function()
        local nvim_tree_api = require("nvim-tree.api")
        -- Change root and reload in background
        nvim_tree_api.tree.change_root(vim.fn.getcwd())
        nvim_tree_api.tree.reload()

        -- Check if nvim-tree was visible in any window
        local was_tree_open = false
        for _, win in pairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "NvimTree" then
            was_tree_open = true
            break
          end
        end

        -- Only reopen if it was previously open
        if was_tree_open then
          nvim_tree_api.tree.open()
        end
      end,
    },
  },
  config = function(_, opts)
    -- Set up auto-session
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    require("auto-session").setup(opts)

    -- Keymaps for session management
    vim.keymap.set("n", "<leader>rs", "<cmd>SessionSave<CR>", { desc = "Save session" })
    vim.keymap.set("n", "<leader>rr", "<cmd>SessionRestore<CR>", { desc = "Restore session" })
    vim.keymap.set("n", "<leader>rd", "<cmd>SessionDelete<CR>", { desc = "Delete session" })
    vim.keymap.set("n", "<leader>ras", "<cmd>SessionToggleAutoSave<CR>", { desc = "Toggle Autosave" })
    vim.keymap.set("n", "<leader>rl", "<cmd>Telescope session-lens search_session<CR>", { desc = "List sessions" })
  end,
}
