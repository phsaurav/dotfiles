return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    require("nvim-treesitter").install({
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
      "gomod",
      "gowork",
      "gosum",
      "javascript",
      "python",
      "terraform",
      "typescript",
      "tsx",
      "css",
      "scss",
    })

    -- Missing parsers must not interrupt filetype setup. Retry when revisiting a buffer.
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("ph-treesitter", { clear = true }),
      callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then return end
        local ft = vim.bo[args.buf].filetype
        if ft == "" then return end
        local lang = vim.treesitter.language.get_lang(ft) or ft
        local ok, loaded = pcall(vim.treesitter.language.add, lang)
        if not ok or not loaded then return end
        if pcall(vim.treesitter.start, args.buf, lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
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

  end,
}
