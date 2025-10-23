return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  dependencies = {
    event = { "BufReadPre", "BufNewFile" },
    "williamboman/mason-lspconfig.nvim",
  },
  ft = { "lua", "python", "go", "dockerfile", "json", "sh", "yaml", "yml", "html", "css", "templ" },
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
        "yamlls",
        "tailwindcss",
        "html",
        "cssls",
        "golangci_lint_ls",
        "templ",
      },
      automatic_installation = true,
      automatic_enable = true
    })

    -- mason_tool_installer.setup({
    --   ensure_installed = {
    --     "prettier", -- prettier formatter
    --   },
    -- })
  end,
}
