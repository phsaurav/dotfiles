return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      modules = {},
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      indent = {
        enable = true,
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
        "typescript",
        "tsx",
        "css",
        "scss"
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-o>",
          node_incremental = "<C-o>",
          scope_incremental = false,
          node_decremental = "<C-i>",
        },
      },
    })

    -- Select markdown fenced code block content (inside only)
    vim.keymap.set("n", "<leader>cb", function()
      local node = vim.treesitter.get_node()
      while node do
        if node:type() == "fenced_code_block" then
          -- Find the code_fence_content child node directly
          for child in node:iter_children() do
            if child:type() == "code_fence_content" then
              local start_row, _, end_row, _ = child:range()
              vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 })
              vim.cmd("normal! V")
              vim.api.nvim_win_set_cursor(0, { end_row, 0 })
              return
            end
          end
          print("Code block is empty")
          return
        end
        node = node:parent()
      end
      print("Not inside a code block")
    end, { desc = "Select code block content" })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown' },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
