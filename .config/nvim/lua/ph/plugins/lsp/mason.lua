return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  dependencies = { "williamboman/mason-lspconfig.nvim" },

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
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "tailwindcss",
        "html",
        "cssls",
        "golangci_lint_ls",
        "templ",
        "ts_ls",
      },
      -- lspconfig.lua enables servers after applying their settings.
      automatic_enable = false
    })

    -- mason_tool_installer.setup({
    --   ensure_installed = {
    --     "prettier", -- prettier formatter
    --   },
    -- })
  end,
}
