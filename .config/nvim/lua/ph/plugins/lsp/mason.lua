return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  dependencies = {
    event = { "BufReadPre", "BufNewFile" },
    "williamboman/mason-lspconfig.nvim",
  },
  cmd = "Mason",
  ft = { "lua", "python", "go", "javascript", "typescript", "terraform", "dockerfile", "json", "sh" },
  config = function()
    local mason = require("mason")
    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")
    -- local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "gopls",
        "bashls",
        "jsonls",
        "pyright",
      },
      automatic_installation = true
    })

    -- mason_tool_installer.setup({
    --   ensure_installed = {
    --     "prettier", -- prettier formatter
    --   },
    -- })
  end,
}
