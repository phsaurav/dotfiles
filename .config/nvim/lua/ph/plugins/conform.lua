return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

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
      formatters = {
        prettier = {
          -- Use the editor width by default; explicit project settings take precedence.
          prepend_args = function(_, ctx)
            return { "--tab-width", tostring(vim.bo[ctx.buf].shiftwidth), "--config-precedence", "file-override" }
          end,
        },
      },
      formatters_by_ft = {
        go = { "gofmt" },
        python = { "black", "isort" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    })
  end,
}
