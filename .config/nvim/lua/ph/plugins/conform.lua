return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    vim.opt.tabstop = 2      -- Number of spaces for a tab
    vim.opt.shiftwidth = 2   -- Indentation size
    vim.opt.expandtab = true -- Use spaces instead of tabs

    -- Automatically format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        conform.format({ bufnr = args.buf })
      end,
    })

    -- Keymap to manually trigger formatting
    vim.keymap.set({ "n", "v" }, "<leader>;", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
      -- Add a message upon format completion
      vim.notify("Formatting complete", vim.log.levels.INFO, {
        title = "Conform.nvim",
        timeout = 2000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Setup conform
    conform.setup({
      formatters_by_ft = {
        go = { "gofmt" },
        python = { "black", "isort" } -- Add isort for import sorting
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    })
  end,
}
